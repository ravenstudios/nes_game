; ZP/RAM


; Returns a uniformly random (col,row) on a 16×15 grid.
; Uses 1 random byte; rejects 240..255 to keep uniform.

RandomCell16x15:
@retry:
    JSR GetRandom          ; A = 0..255
    CMP #$f0
    BCS @retry             ; reject 240..255

    ; A = 0..239
    STA rand_row           ; save for row calc
    AND #$0F               ; low nibble = col
    STA rand_col           ; 0..15
    STA $0040
    LDA rand_row

    LSR A                  ; divide by 16 → row 0..14
    LSR A
    LSR A
    LSR A
    STA rand_row
    STA $0041
    RTS

; LoadRandomTiles:
; 	LDA $2002		;read PPU status to reset high/low latch
; 	LDA #$20	;start of nametable "canvas" as the high bit
; 	STA $2006	
; 	LDA #$00	;sets low bit
; 	STA $2006	;what adress to write to starting at $2100
; 	LDX #$00	;bad code that uses wraparound to hit 0 in the loop

LoadRandomRoom:
; want: tile #$04 at (5,5) in NT0 ($2000)


@loop:
    JSR RandomCell16x15
    LDA $2002        ; reset latch
    LDA #$22         ; high byte of $20A5
    STA $2006
    LDA #$c4         ; low byte of $20A5
    STA $2006
    LDA #$04         ; tile index
    STA $2007
    TAX
    INX
    STX $2007

    LDA $2002        ; reset latch
    LDA #$22         ; high byte of $20A5
    STA $2006
    LDA #$e4        ; low byte of $20A5
    STA $2006
    LDA #$14         ; tile index
    STA $2007
    TAX
    INX
    STX $2007


    ; re-set scroll after any $2006/$2007 writes
    LDA $2002
    LDA #$00
    STA $2005        ; X scroll
    STA $2005        ; Y scroll

    INC loop_counter
    LDA loop_counter

    CMP #$0A
    BNE @loop


    RTS


    