.include "init_vars.asm"
.include "background.asm"
; .include "test_room.asm"
.include "sprites.asm"
; .include "random_room.asm"
.include "start_screen.asm"


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

; --- PPU Warmup: wait 2 vblanks ---
    BIT $2002
@vb1:
    BIT $2002
    BPL @vb1
@vb2:
    BIT $2002
    BPL @vb2

	

	;SETTING SPRITE RANGE
	LDA #$02
	STA $4014
	NOP
	
	
	;load background pallet
	LDA $2002
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

JSR INITVARS




; JSR LOADBACKGROUND
JSR LoadTitleScreenBackground
; LDA #10         ; place 10 random blocks
; LDX #$04        ; meta-tile TL id = $04
; JSR LoadRandomRoom


	CLI

	LDA #%10010000
	STA $2000			;WHEN VBLANK OCCURS CALL NMI

	LDA #%00011110		;show sprites and background
	STA $2001

	
	JMP INFLOOP


