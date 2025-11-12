Timer_Update:
    DEC timer_tick_counter
    BNE @skip
        LDA #TIMER_FPS
        STA timer_tick_counter
        DEC timer_counter
        LDA timer_counter
        STA $0050

        ; TIMER_DIGIT_Y = $04
        ; TIMER_DIGIT_X1 = $18
        ; TIMER_DIGIT_X1 = $19
        ; TIMER_DIGIT_X1 = $1A     

        ; ; A=tile, X=col, Y=row

        JSR GetDecimalDigits
        LDX hundreds
        LDA NumberTiles, X
        STA loadedTile
        LDY #TIMER_DIGIT_Y
        LDX #TIMER_DIGIT_X1
        JSR SetBGTile

        JSR GetDecimalDigits
        LDX tens
        LDA NumberTiles, X
        STA loadedTile
        LDY #TIMER_DIGIT_Y
        LDX #TIMER_DIGIT_X2
        JSR SetBGTile

        JSR GetDecimalDigits
        LDX ones
        LDA NumberTiles, X
        STA loadedTile
        LDY #TIMER_DIGIT_Y
        LDX #TIMER_DIGIT_X3
        JSR SetBGTile
        ; LDA #num_1_tile
        ; STA loadedTile
        ; LDY #TIMER_DIGIT_Y
        ; LDX #TIMER_DIGIT_X2
        ; JSR SetBGTile

        ; LDA #num_2_tile
        ; STA loadedTile
        ; LDY #TIMER_DIGIT_Y
        ; LDX #TIMER_DIGIT_X3
        ; JSR SetBGTile
       
    
@skip:
    RTS

NumberTiles:
    .byte $d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2



; input:  timer_counter (0–255)
; output: hundreds, tens, ones
; trashes: A, X, Y
GetDecimalDigits:
    LDA timer_counter
    LDX #0          ; hundreds
@hundreds:
    CMP #100
    BCC @tens_start
    SBC #100
    INX
    JMP @hundreds
@tens_start:
    STX hundreds
    LDX #0          ; tens
@tens:
    CMP #10
    BCC @ones_start
    SBC #10
    INX
    JMP @tens
@ones_start:
    STX tens
    STA ones
    RTS