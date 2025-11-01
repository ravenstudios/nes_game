.segment "HEADER"
	.byte "NES"		;identification string
	.byte $1A
	.byte $02		;amount of PRG ROM in 16K units
	.byte $01		;amount of CHR ROM in 8K units
	.byte $00		;mapper and mirroing
	.byte $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00


.segment "ZEROPAGE"
XVEL: .RES 1

.segment "STARTUP"
RESET:
	SEI 		;disables interupts
	CLD			;turn off decimal mode
	
	LDX #%1000000	;disable sound IRQ
	STX $4017
	LDX #$00
	STX $4010		;disable PCM
	
	;initialize the stack register
	LDX #$FF
	TXS 		;transfer x to the stack
	
	; Clear PPU registers
	LDX #$00
	STX $2000
	STX $2001
	
	;WAIT FOR VBLANK
:
	BIT $2002
	BPL :-
	
	;CLEARING 2K MEMORY
	TXA
CLEARMEMORY:		;$0000 - $07FF
	STA $0000, X
	STA $0100, X
	STA $0300, X
	STA $0400, X
	STA $0500, X
	STA $0600, X
	STA $0700, X
		LDA #$FF
		STA $0200, X
		LDA #$00
	INX
	CPX #$00
	BNE CLEARMEMORY

	;WAIT FOR VBLANK
:
	BIT $2002
	BPL :-
	

	

	;SETTING SPRITE RANGE
	LDA #$02
	STA $4014
	NOP
	
	LDA #$3F	;$3F00
	STA $2006
	LDA #$00
	STA $2006
	
	LDX #$00
	
LOADPALETTES:
	LDA PALETTEDATA, X
	STA $2007
	INX
	CPX #$20
	BNE LOADPALETTES

;LOADING SPRITES
	LDX #$00
LOADSPRITES:
	LDA SPRITEDATA, X
	STA $0200, X
	INX
	CPX #$10	;16bytes (4 bytes per sprite, 8 sprites total)
	BNE LOADSPRITES

;LOADING BACKGROUND
	
LOADBACKGROUND:
	LDA $2002		;read PPU status to reset high/low latch
	LDA #$21
	STA $2006
	LDA #$00
	STA $2006
	LDX #$00

	
;ENABLE INTERUPTS
CLI

LDA #%10010000
STA $2000			;WHEN VBLANK OCCURS CALL NMI

LDA #%00011110		;show sprites and background
STA $2001

VARS:
	LEFT  = $5
	RIGHT = 238
	LDX #$02
	STX XVEL

INFLOOP:
	JMP INFLOOP


NMI:
    ; move by signed velocity in XVEL
    LDA $0203
    CLC
    ADC XVEL          ; <<< was $00 — use XVEL
    STA $0203
	STA $020b
	CLC
	ADC #8
	STA $0207
	STA $020f

    ; bounce on RIGHT
    LDA $0203
    CMP #RIGHT
    BCC :+
        LDA #RIGHT
        STA $0203
        LDA XVEL
        EOR #$FF
        CLC
        ADC #1
        STA XVEL
:
    ; bounce on LEFT
    LDA $0203
    CMP #LEFT
    BCS :+
        LDA #LEFT
        STA $0203
        LDA XVEL
        EOR #$FF
        CLC
        ADC #1
        STA XVEL
:
    LDA #$02
    STA $4014
    RTI


PALETTEDATA:
	.byte $00, $0F, $00, $10, 	$00, $0A, $15, $01, 	$00, $29, $28, $27, 	$00, $34, $24, $14 	;background palettes
	.byte $31, $0F, $15, $30, 	$00, $0F, $11, $30, 	$00, $0F, $30, $27, 	$00, $3C, $2C, $1C 	;sprite palettes

SPRITEDATA:
;Y, SPRITE NUM, attributes, X
;76543210
;||||||||
;||||||++- Palette (4 to 7) of sprite
;|||+++--- Unimplemented
;||+------ Priority (0: in front of background; 1: behind background)
;|+------- Flip sprite horizontally
;+-------- Flip sprite vertically
	.byte $40, $00, $00, $40
	.byte $40, $01, $00, $48
	.byte $48, $10, $00, $40
	.byte $48, $11, $00, $48
	





.segment "VECTORS"
	.word NMI
	.word RESET
	; specialized hardware interurpts
.segment "CHARS"
	.incbin "rom.chr"

