Gameover:
    
    JSR ClearBackground
    LDA #$02
    STA state
    JSR DrawGameover
    
    RTS



; GAMEOVER_TEXT_X = #$7b
; GAMEOVER_TEXT_Y = $#78
gameover_string:
    .byte $c6, $c0, $cc, $c4, $ce, $d5, $c4, $d1
DrawGameover:

    LDX #$00
    @loop:
        CPX #$08
        BEQ @done
            LDA gameover_string, X
            STA loadedTile

            LDY #GAMEOVER_TEXT_Y
            TXA
            PHA
            CLC
            ADC #GAMEOVER_TEXT_X
            TAX
            JSR SetBGTile
            PLA
            TAX
            INX
            JMP @loop

    @done:
        RTS

GameoverUpdate:

    JSR ReadController1
    LDA controller1_prev
    AND #STARTBTN
    BNE @done
        LDA controller1
        AND #STARTBTN
        BEQ @done
            
            LDA #$00
            STA state
            STA start_screen
            JSR LoadTitleScreenBackground
@done:
    RTS