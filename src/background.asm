

LOADBACKGROUND:

	LDA $2002		;read PPU status to reset high/low latch
	LDA #$20	;start of nametable "canvas" as the high bit
	STA $2006	
	LDA #$00	;sets low bit
	STA $2006	;what adress to write to starting at $2100
	LDX #$00	;bad code that uses wraparound to hit 0 in the loop
LOADBACKGROUNDP1:
	LDA BACKGROUNDDATA, X ;loop through BACKGROUNDDATA
	STA $2007 ; store byte
	LDA COLLISIONTABLEDATA, X
	; STA COLLISIONTABLE
	INX
	CPX #$00 ;wrap around
	BNE LOADBACKGROUNDP1 ; if x == 0 break
LOADBACKGROUNDP2:
	LDA BACKGROUNDDATA+256, X
	STA $2007
	LDA COLLISIONTABLEDATA+256, X
	; STA COLLISIONTABLE
	INX
	CPX #$00
	BNE LOADBACKGROUNDP2
LOADBACKGROUNDP3:
	LDA BACKGROUNDDATA+512, X
	STA $2007
	LDA COLLISIONTABLEDATA+512, X
	; STA COLLISIONTABLE
	INX
	CPX #$00
	BNE LOADBACKGROUNDP3
LOADBACKGROUNDP4:
	LDA BACKGROUNDDATA+768, X
	STA $2007
	LDA COLLISIONTABLEDATA+768, X
	; STA COLLISIONTABLE
	INX
	CPX #$c0
	BNE LOADBACKGROUNDP4
;192

;LOAD BACKGROUND PALETTEDATA
	LDA #$23	
	STA $2006
	LDA #$c0
	STA $2006
	LDX #$00
LOADBACKGROUNDATTRDATA:
	LDA BACKGROUNDATTRDATA, X
	STA $2007
	INX
	CPX #$40
	BNE LOADBACKGROUNDATTRDATA

	;RESET SCROLL
	LDA #$00
	STA $2005
	STA $2005



RTS
	

SetTilePushable:
	TYA
	LSR
	LSR
	LSR
	LSR                  ; A = y_tile (0..14)
	ASL
	ASL
	ASL
	ASL                  ; A = y_tile * 16
	STA tmp              ; tmp = row offset

	TXA
	LSR
	LSR
	LSR
	LSR                  ; A = x_tile (0..15)
	CLC
	ADC tmp              ; A = index (0..239)
	TAX

	LDA #$02             ; e.g., 2 = pushable block (or 1 if you treat it as solid)
	STA COLLISIONTABLE,X
	RTS


UnsetTileSolid:
	TYA
	LSR
	LSR
	LSR
	LSR                  ; A = y_tile (0..14)
	ASL
	ASL
	ASL
	ASL                  ; A = y_tile * 16
	STA tmp              ; tmp = row offset

	TXA
	LSR
	LSR
	LSR
	LSR                  ; A = x_tile (0..15)
	CLC
	ADC tmp              ; A = index (0..239)
	TAX

	LDA #$00             ; e.g., 2 = pushable block (or 1 if you treat it as solid)
	STA COLLISIONTABLE,X
	RTS

SetTileSolid1:
	TYA
	LSR
	LSR
	LSR
	LSR                  ; A = y_tile (0..14)
	ASL
	ASL
	ASL
	ASL                  ; A = y_tile * 16
	STA tmp              ; tmp = row offset

	TXA
	LSR
	LSR
	LSR
	LSR                  ; A = x_tile (0..15)
	CLC
	ADC tmp              ; A = index (0..239)
	TAX

	LDA #$01             ; e.g., 2 = pushable block (or 1 if you treat it as solid)
	STA COLLISIONTABLE,X
	RTS



PALETTEDATA:
	.byte $20, $31, $22, $11, 	$20, $0A, $15, $01, 	$20, $29, $28, $27, 	$20, $34, $24, $14 	;background palettes
	.byte $20, $27, $13, $0f, 	$20, $0F, $11, $30, 	$20, $0F, $30, $27, 	$20, $3C, $2C, $1C 	;sprite palettes

BACKGROUNDDATA:
	.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03
	.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13
	
    .byte $8b,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8c,$8d
    .byte $9b,$00,$00,$e4,$e4,$e4,$e4,$e4,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$d3,$c8,$cc,$c4,$e3,$dc,$d9,$d9,$00,$00,$00,$00,$9d
	.byte $9b,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$9d
	.byte $ab,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ac,$ad
    
	
	
	.byte $02,$03,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$02,$03
	.byte $12,$13,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$12,$13
	
	.byte $02,$03,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$08,$09,$02,$03
	.byte $12,$13,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$18,$19,$12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	
	
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	
	
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b ,$02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	.byte $02,$03, $0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b,$0a,$0b, $02,$03
	.byte $12,$13, $1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b,$1a,$1b, $12,$13
	
	.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03,$02,$03
	.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13,$12,$13

;0-blue
;1-green
;2-yellow
;3-pink
;br - bl - tr - tl

BACKGROUNDATTRDATA:
  .byte $00, $00, $00, $00, $00, $00, $00, $00
  .byte $40, $50, $50, $50, $50, $50, $50, $10
  .byte $c4, $f5, $f5, $f5, $f5, $f5, $f5, $31
  .byte $cc, $ff, $ff, $ff, $ff, $ff, $ff, $33
  .byte $cc, $ff, $ff, $ff, $ff, $ff, $ff, $33
  .byte $cc, $ff, $ff, $ff, $ff, $ff, $ff, $33
  .byte $cc, $ff, $ff, $ff, $ff, $ff, $ff, $33
  .byte $c0, $f0, $f0, $f0, $f0, $f0, $f0, $00


COLLISIONTABLEDATA:
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
	.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	

LoadCollisionTable:
    LDX #$00
@copy:
    CPX #240            ; 16*15
    BEQ @done
    LDA COLLISIONTABLEDATA, X
    STA COLLISIONTABLE, X
    INX
    BNE @copy
@done:
    RTS



; tmp0/tmp1 are 16-bit scratch in zeropage (low/high)
; A=tile, X=col, Y=row

; A=tile, X=col, Y=row
; A = tile, X = col (0..31), Y = row (0..29)
SetBGTile:
    ; --- wait for start of vblank ---
@vbwait:
    BIT $2002
    BPL @vbwait          ; loop until vblank begins (bit7=1)

    ; --- render OFF while touching VRAM ---
    LDA #$00
    STA $2001

    ; PHA                  ; save tile in A

    ; addr = $2000 + row*32 + col
    TYA
    STA tmp0
    LDA #$00
    STA tmp1
    ASL tmp0
 	ROL tmp1  ; *2
    ASL tmp0
 	ROL tmp1  ; *4
    ASL tmp0
 	ROL tmp1  ; *8
    ASL tmp0
 	ROL tmp1  ; *16
    ASL tmp0
 	ROL tmp1  ; *32

    CLC
    LDA tmp0
    ADC #<$2000
    STA tmp0
    LDA tmp1
    ADC #>$2000
    STA tmp1

    TXA
    CLC
    ADC tmp0
    STA tmp0
    LDA tmp1
    ADC #$00
    STA tmp1

    ; do the write
    LDA $2002
    LDA tmp1
    STA $2006
    LDA tmp0
    STA $2006

    LDA loadedTile
	STA $00c0
    STA $2007

    ; --- restore scroll & render ON (no scrolling: both 0) ---
    LDA #$00
    STA $2005
    STA $2005
    LDA #%00011110
    STA $2001
    RTS