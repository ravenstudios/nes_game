

LOADBACKGROUND:
	LDA $2002		
	LDA #$20	
	STA $2006	
	LDA #$40
	STA $2006	


	LDX #$00	
    LDY #$00
    LDA #$00

LOADBACKGROUNDP:
	LDA BACKGROUNDDATA, X 
	STA $2007
	INX
	CPX #10 
	BNE LOADBACKGROUNDP ; if x == 0 break


    LDA $2002		
	LDA #$20	
	STA $2006	
	LDA #$60
	STA $2006	

    LDX #$00



LOADBACKGROUNDP2:
	LDA BACKGROUNDDATA+10, X 
	STA $2007
	INX
	CPX #10 
	BNE LOADBACKGROUNDP2 ; if x == 0 break
    ; INY
    ; LDA $2002		;read PPU status to reset high/low latch
	; LDA #$20	;start of nametable "canvas" as the high bit
	; STA $2006	
	; LDA #$20	;sets low bit
	; STA $2006
    ; LDX #$00
    ; CPY #$0A
    ; BNE LOADBACKGROUNDP


; .byte $02,$03,$02,$03,$02,$03,$02,$03,$02,$03
; .byte $12,$13,$12,$13,$12,$13,$12,$13,$12,$13

;reset h/l bit in $2002
;set $2000 high bit to $20 sta in 2006 and set low bit then sta $2006

;loop through X bytes of map data where X is the W of map, using a var or register to index loop

;sta each byte into $2007

;reset inside loop counter

;inc outside loop counter

;set low bit for $2006 that is 32 - map width

;go back to inner loop and offset reading data by map w * row












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
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
.byte $fe, $fe, $fe, $fe, $fe, $fe, $fe, $fe
