.include "player.asm"
.include "input.asm"
.include "enemy.asm"
.include "chaser.asm"
.include "animate.asm"
.include "moveable_block.asm"
.include "bullet.asm"
.include "timer.asm"
.include "door.asm"
.include "gameover.asm"
.include "map_loader.asm"


INFLOOP:


@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag

    INC frame_counter

    ;START STATE
    LDA state
    CMP #$00
    BNE :+
    JSR StartScreenStateUpdate
    JSR StartScreenStateUpdatDraw
    :

    ;GAME STATE
    LDA state
    CMP #$01
    BNE :+
        JSR UpdateGameLoop
        JSR DrawGameLoop
    :
    
    ;GAME OVER STATE
    LDA state
    CMP #$02
    BNE :+
        JSR ClearOAM
        JSR GameoverUpdate
        ; JSR DrawGameover
    :
lda state
sta $0100
JMP INFLOOP




UpdateGameLoop:
    JSR TimerUpdate
    JSR PlayerHitTimer
    JSR GetRandom
    JSR ReadController1
    JSR HandleDpad
    JSR EnemyUpdate
    JSR GetNewEnemyRandomWalkTimer
    ; JSR UpdateMoveableBlock
    JSR UpdateBulet
    JSR DoorUpdate
    JSR UpdatePlayer
@return:
    RTS



DrawGameLoop:
    JSR ANITMATION
    JSR DrawEnemies
    JSR DRAWPLAYER
    ; JSR DrawAllBlocks
    JSR DrawBullet   
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


GetRandom:
    LDA rand8
    LSR A          ; shift right, bit0 -> carry
    BCC no_xor
    EOR #$B8       ; tap polynomial

no_xor:
    STA rand8
    RTS






LoadState1:
    ; JSR LoadRandomRoom
    ; JSR LOADSPRITES
    JSR LoadLevel
    JSR LoadEnemies
    ; JSR LoadBlocks
    JSR UpdateHealth
    JSR LoadPlayer
    JSR Move_enemies_off_screen
    RTS