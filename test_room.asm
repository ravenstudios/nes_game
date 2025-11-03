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
	INX
	CPX #$00 ;wrap around
	BNE LOADBACKGROUNDP1 ; if x == 0 break
LOADBACKGROUNDP2:
	LDA BACKGROUNDDATA+256, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP2
LOADBACKGROUNDP3:
	LDA BACKGROUNDDATA+512, X
	STA $2007
	INX
	CPX #$00
	BNE LOADBACKGROUNDP3
LOADBACKGROUNDP4:
	LDA BACKGROUNDDATA+768, X
	STA $2007
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

	;ENABLE INTERUPTS

	;init vars

	
	

	


	


PALETTEDATA:
	.byte $00, $31, $22, $11, 	$00, $0A, $15, $01, 	$00, $29, $28, $27, 	$00, $34, $24, $14 	;background palettes
	.byte $00, $27, $13, $0f, 	$00, $0F, $11, $30, 	$00, $0F, $30, $27, 	$00, $3C, $2C, $1C 	;sprite palettes

BACKGROUNDDATA:
.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13
.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13
.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13
.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13
.byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
.byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13

BACKGROUNDATTRDATA:
  .byte $40, $50, $50, $50, $50, $50, $50, $10
  .byte $44, $55, $55, $55, $55, $55, $55, $11
  .byte $c0,$cf, $ff, $ff, $ff, $ff, $ff, $33
  .byte $cc, $f3, $cf, %10101010, $ff, $ff, $ff, $33
  .byte $cc, $ff, %11110011, %11001111, $ff, $ff, $ff, $33
  .byte $cc, $ff, $ff, $ff, %11001111, $ff, $ff, $33
  .byte $cc, $ff, $ff, $ff, $ff, $ff, $ff, $33
  .byte $c0, $f0, $f0, $f0, $f0, $f0, $f0, $00