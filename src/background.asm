

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


; Clear the collision tile we just checked in CheckTile
UnsetTileSolid:
    TAX
    LDA #$00
    STA COLLISIONTABLE, X
    RTS


SetTileSolid1:
    TAX
    LDA #$01
    STA COLLISIONTABLE, X
    RTS



SetTileDoor:

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

	LDA #$03         ; e.g., 2 = pushable block (or 1 if you treat it as solid)
	STA COLLISIONTABLE,X
	RTS

UnsetTileDoor:

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

	LDA #$01        ; e.g., 2 = pushable block (or 1 if you treat it as solid)
	STA COLLISIONTABLE,X
	RTS



PALETTEDATA:
.byte $0f, $27, $13, $0f
.byte $20, $0A, $15, $01
.byte $20, $29, $28, $27
.byte $20, $34, $24, $14
;sprite palettes
.byte $0f, $27, $13, $0f ;shouold be sprite but changing this changes
.byte $20, $20, $11, $30
.byte $20, $20, $30, $27
.byte $20, $3C, $2C, $1C 	;background palettes

BACKGROUNDDATA:

.byte $EC,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EB,$EA
.byte $E8,$FF,$CB,$C8,$D5,$C4,$D2,$FF,$FF,$FF,$FF,$FF,$FF,$CB,$C4,$D5,$C4,$CB,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$E3,$FF,$FF,$E9
.byte $E7,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E6,$E5
.byte $4B,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4E,$4F
.byte $5B,$5C,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5D,$5E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$04,$05,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$14,$15,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $5B,$6C,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$F4,$6E,$7F
.byte $7B,$7C,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7D,$7E,$7F
.byte $8B,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8C,$8F

;0-blue
;1-green
;2-yellow
;3-pink
;br - bl - tr - tl

BACKGROUNDATTRDATA:
  .byte $01, $01, $01, $01, $01, $01, $01, $01
	.byte $01, $01, $01, $01, $01, $01, $01, $01
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00


COLLISIONTABLEDATA:
	

.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$01,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$01,$00,$00,$01,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$01,$00,$00,$00,$00,$00,$00,$00,$00,$01,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$01
.byte $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
	

; LoadCollisionTable:
;     LDX #$00
; @copy:
;     CPX #240            ; 16*15
;     BEQ @done
;     LDA COLLISIONTABLEDATA, X
;     STA COLLISIONTABLE, X
;     INX
;     BNE @copy
; @done:
;     RTS



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
    STA $2007

    ; --- restore scroll & render ON (no scrolling: both 0) ---
    LDA #$00
    STA $2005
    STA $2005
    LDA #%00011110
    STA $2001
    RTS


ClearBackground:
    INC $0081
    ; disable rendering
    LDA #$00
    STA $2001

    ; set VRAM addr = $2000
    LDA $2002
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006

    ; 960 bytes = $03C0
    LDY #$03       ; high byte
    LDX #$C0       ; low byte
ClearLoop:
    INC $0083
    LDA #$00
    STA $2007      ; write blank tile

    DEX
    BNE ClearLoop  ; loop until X wraps to 0

    DEY
    BPL ClearLoop  ; run for Y = 3,2,1,0 (stop when Y becomes $FF)

    ; re-enable rendering
    LDA #%00011110
    STA $2001
    RTS





ClearOAM:
	LDA #$FF
	LDX #$00
	@loop:
    STA $0200, X
    INX
    BNE @loop
	RTS