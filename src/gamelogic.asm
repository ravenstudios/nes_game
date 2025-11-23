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
.include "mimic.asm"

INFLOOP:

@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag

    INC frame_counter

    

    ; ===== UPDATE section =====
    ; START STATE
    LDA state
    CMP #$00
    BNE :+
        JSR StartScreenStateUpdate
    :

    ; GAME STATE
    LDA state
    CMP #$01
    BNE :+
        JSR UpdateGameLoop
    :

    ; GAME OVER STATE
    LDA state
    CMP #$02
    BNE :+
        JSR ClearOAM
    :

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
    JSR UpdateMapLoader
    JSR MimicUpdate
@return:
    RTS



DrawGameLoop:

    JSR TimerDraw
    JSR DrawDoor
    JSR Undraw_door
    JSR ANITMATION
    JSR DrawEnemies
    JSR DRAWPLAYER
    JSR DrawMoveableBlock
    JSR DrawBullet   
    JSR DrawMimic

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

    ; ===== OAM DMA FIRST (fast, doesn’t touch VRAM) =====
    LDA vram_busy
    BNE skip_dma
        LDA #$02
        STA $4014         ; copy $0200..$02FF to OAM
skip_dma:

    ; ===== DRAW section =====
    ; START STATE
    LDA state
    CMP #$00
    BNE :+
        JSR StartScreenStateUpdatDraw
    :

    ; GAME STATE
    LDA state
    CMP #$01
    BNE :+
        JSR DrawGameLoop   ; DrawDoor, enemies, player, mimic, etc.
    :

    ; GAME OVER
    LDA state
    CMP #$02
    BNE :+
        JSR ClearOAM
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
    ; JSR LoadEnemies
    ; JSR LoadBlocks
    ; JSR UpdateHealth
    JSR LoadPlayer
    JSR LoadMimic
    RTS