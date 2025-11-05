.include "input.asm"

INFLOOP:


@wait_vblank:
    JSR ReadController1
    

    ; write X
    LDA PLAYER_X
    STA $0203
    STA $020b
    CLC
    ADC #8
    STA $0207
    STA $020f

    ; write Y
    LDA PLAYER_Y
    STA $0200
    STA $0204
    CLC
    ADC #8
    STA $0208
    STA $020c

    LDA #$60
    STA ENEMY_X
    LDA #$90
    STA ENEMY_Y
   


JSR AnimatePlayer

JMP INFLOOP


NMI:
    PHA
    TXA
    PHA
    TYA
    PHA

    LDA #1
    STA vblank_flag
    
    ;Draw
    LDA #$02
    STA $4014

    PLA
    TAY
    PLA
    TAX
    PLA
    RTI