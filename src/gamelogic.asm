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


    LDA state
    CMP #$00
    BCC :+
    JSR StartScreenStateUpdate
    JSR StartScreenStateUpdatDraw
    :

    LDA state
    CMP #$01
    BCC :+
    JSR UpdateGameLoop
    JSR DrawGameLoop
    :

    ; LDA ENEMYDIRECTION
JMP INFLOOP


StartScreenStateUpdate:
    JSR ReadController1

    ; if *any* button is pressed, set start_screen=1 once
    LDA start_screen
    BNE @done                ; already set

    LDA controller1
    BEQ @done                ; no buttons this frame

    LDA #$01
    STA start_screen
    LDA #10         ; place 10 random blocks
    LDX #$04        ; meta-tile TL id = $04
    JSR LoadRandomRoom
    JSR LOADSPRITES

    
@done:
    ; advance state if start_screen==1
    LDA start_screen
    CMP #$01
    BNE :+
        INC state
        
        ; STA start_screen
        
    :
    RTS


StartScreenStateUpdatDraw:
    ; LDA #$00
    ; STA $2000
    ; STA $2001  
    RTS

UpdateGameLoop:
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

DrawGameLoop:
    JSR ANITMATION
    JSR DRAWENEMY
    JSR DRAWCHASERENEMY
    JSR DRAWPLAYER
RTS

NMI:
    INC rand8
    
       
    
    PHA
    TXA
    PHA
    TYA
    PHA



    LDA #1
    STA vblank_flag
    
    LDA vram_busy
    BNE :+
    ;Draw
    LDA #$02
    STA $4014
    :

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