TimerUpdate:
    DEC timer_tick_counter
    LDA timer_tick_counter
    BNE @skip

        LDA #TIMER_FPS
        STA timer_tick_counter ;reset
        
        LDA #$01
        STA can_draw_timer
        
        ;get timer_s
        LDA timer_s
        BNE :+
            LDA #$09
            STA timer_s
            DEC timer_ts
        ;dec timer_s
        :

        LDA timer_ts
        BNE :+
            LDA #$05
            STA timer_ts
            DEC timer_m
        :
    
    DEC timer_s
    
@skip:
    RTS


TimerDraw:
    LDA can_draw_timer
    CMP #$01
    BNE @done

    LDA #$00
    STA can_draw_timer

    LDX timer_m
    LDA NumberTiles, X
    STA loadedTile
    LDY #TIMER_DIGIT_Y
    LDX #TIMER_DIGIT_X1
    JSR SetBGTile
    
    
    LDX timer_ts
    LDA NumberTiles, X
    STA loadedTile
    LDY #TIMER_DIGIT_Y
    LDX #TIMER_DIGIT_X2
    JSR SetBGTile

    LDX timer_s
    LDA NumberTiles, X
    STA loadedTile
    LDY #TIMER_DIGIT_Y
    LDX #TIMER_DIGIT_X3
    JSR SetBGTile


    LDX level
    INX
    LDA NumberTiles, X
    STA loadedTile
    LDY #TIMER_DIGIT_Y
    LDX #LEVEL_X
    JSR SetBGTile
@done:
    RTS

NumberTiles:
    .byte $d9,$da,$db,$dc,$dd,$de,$df,$e0,$e1,$e2



 