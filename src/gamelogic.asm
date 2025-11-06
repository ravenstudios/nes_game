.include "player.asm"
.include "input.asm"
.include "enemy.asm"
.include "chaser.asm"
.include "animate.asm"
INFLOOP:


@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag  
    JSR UPDATE
    JSR DRAW

    LDA ENEMYDIRECTION
JMP INFLOOP






UPDATE:
    JSR GetRandom
    JSR ReadController1
    JSR HandleDpad
    JSR ENEMYWALK
    
    JSR GetNewEnemyRandomWalkTimer


    INC CHASERSPEEDCOUNTER
    LDA CHASERSPEEDCOUNTER
    STA $0050
    CMP #$04
    BNE @return
        JSR CHASERENEMYWALK
        LDA #$00
        STA CHASERSPEEDCOUNTER
@return:
    RTS

DRAW:
    JSR ANITMATION
    JSR DRAWENEMY
    JSR DRAWCHASERENEMY
    JSR DRAWPLAYER
RTS

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



; rand8 = (rand8 >> 1) ^ (carry ? $B8 : 0)
; returns A = rand8
GetRandom:
    LDA rand8
    LSR A          ; shift right, bit0 -> carry
    BCC no_xor
    EOR #$B8       ; tap polynomial
no_xor:
    STA rand8
    RTS