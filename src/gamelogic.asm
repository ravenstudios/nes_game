.include "player.asm"
.include "input.asm"
.include "enemy.asm"
.include "chaser.asm"
.include "animate.asm"
.include "moveable_block.asm"
.include "bullet.asm"
.include "timer.asm"


INFLOOP:


@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag

    LDA #HitTimer
    INC frame_counter

    ; --- hit flash timer (safe, no underflow) ---
    LDA is_player_hit
    BEQ @done                ; not active → skip

    LDA player_hit_timer
    BEQ @clear               ; already 0 → clear & stop

    DEC player_hit_timer     ; count down once per frame
    LDA player_hit_timer
    
    BNE @done                ; still >0 → done

@clear:
    LDA #$00
    STA is_player_hit
    STA player_hit_timer     ; keep it at 0

@done:


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
    BNE skip                ; already set

    LDA controller1
    BEQ skip                ; no buttons this frame

    LDA #$01
    STA start_screen
    LDA #10         ; place 10 random blocks
    LDX #$04        ; meta-tile TL id = $04
    JSR LoadRandomRoom
    JSR LOADSPRITES
    JSR LoadEnemies
    JSR LoadBlocks


LoadEnemies:
    LDX #$00
@loop:
    CPX enemy_count
    BCS @done                ; stop when X >= enemy_count

    TXA                      ; A = X
    ASL                      ; A = 2*X
    TAY                      ; Y = 2*X

    LDA EnemyPos, Y          ; x
    STA enemy_x, X
    INY
    LDA EnemyPos, Y          ; y
    STA enemy_y, X

    INX
    BNE @loop                ; (enemy_count <= 255)
@done:
    RTS



; LDX #$00

; LDA #$20
; STA moveable_block_x, X
; STA moveable_block_y, X
; LDY moveable_block_y, X
; LDA moveable_block_x, X
; TAX
; JSR SetTilePushable

; LDX #$01
; LDA #$30
; STA moveable_block_x, X
; STA moveable_block_y, X
; LDY moveable_block_y, X
; LDA moveable_block_x, X
; TAX
; JSR SetTilePushable

LoadBlocks:
    LDX #$00
@loop:
    CPX moveable_block_count
    BCS @done                ; stop when X >= enemy_count

    TXA                      ; A = X
    ASL                      ; A = 2*X
    TAY                      ; Y = 2*X

    LDA BlockPos, Y          ; x
    STA moveable_block_x, X
    INY
    LDA BlockPos, Y          ; y
    STA moveable_block_y, X

    TXA 
    PHA

    LDA moveable_block_x, X
    LDY moveable_block_y, X

    TAX
    JSR SetTilePushable

    PLA
    TAX
    INX
    BNE @loop                ; (enemy_count <= 255)
@done:
    RTS

    
skip:
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
    JSR EnemyUpdate
    
    JSR GetNewEnemyRandomWalkTimer


    ; INC CHASERSPEEDCOUNTER
    ; LDA CHASERSPEEDCOUNTER
    ; CMP #$04
    ; BNE @return
    ;     JSR CHASERENEMYWALK
    ;     LDA #$00
    ;     STA CHASERSPEEDCOUNTER

    JSR UpdateMoveableBlock
    JSR UpdateBulet
@return:
    RTS



DrawGameLoop:
    JSR ANITMATION
    JSR DrawEnemies
    ; JSR DRAWCHASERENEMY
    JSR DRAWPLAYER
    ; JSR DrawMoveableBlock
    JSR DrawAllBlocks
    JSR DrawBullet
     JSR Timer_Update
    
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


EnemyPos:
    .byte $20, $60
    .byte $60, $60
    .byte $20, $80


BlockPos:
    .byte $50, $60
    .byte $80, $60
    .byte $a0, $a0
