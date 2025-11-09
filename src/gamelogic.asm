.include "player.asm"
.include "input.asm"
.include "enemy.asm"
.include "chaser.asm"
.include "animate.asm"
.include "moveable_block.asm"

INFLOOP:


@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag

    LDA #HitTimer
    STA $0010
    INC frame_counter

    ; --- hit flash timer (safe, no underflow) ---
    LDA is_player_hit
    BEQ @done                ; not active → skip

    LDA player_hit_timer
    BEQ @clear               ; already 0 → clear & stop

    DEC player_hit_timer     ; count down once per frame
    LDA player_hit_timer
    STA $0000
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
    BNE @done                ; already set

    LDA controller1
    BEQ @done                ; no buttons this frame

    LDA #$01
    STA start_screen
    LDA #10         ; place 10 random blocks
    LDX #$04        ; meta-tile TL id = $04
    JSR LoadRandomRoom
    JSR LOADSPRITES

   ; index = (moveable_block_y >> 4) * 16 + (moveable_block_x >> 4)
; LDA moveable_block_y
; LSR
; LSR
; LSR
; LSR                  ; A = y_tile (0..14)
; ASL
; ASL
; ASL
; ASL                  ; A = y_tile * 16
; STA tmp              ; tmp = row offset

; LDA moveable_block_x
; LSR
; LSR
; LSR
; LSR                  ; A = x_tile (0..15)
; CLC
; ADC tmp              ; A = index (0..239)
; TAX

; LDA #$02             ; e.g., 2 = pushable block (or 1 if you treat it as solid)
; STA COLLISIONTABLE,X

LDX #$00
LDA #$40
STA moveable_block_x, X
STA moveable_block_y, X
LDY moveable_block_y, X
LDA moveable_block_x, X
TAX
JSR SetTilePushable

LDX #$01
LDA #$60
STA moveable_block_x, X
STA moveable_block_y, X
LDY moveable_block_y, X
LDA moveable_block_x, X
TAX
JSR SetTilePushable

LDX #$02
LDA #$80
STA moveable_block_x, X
STA moveable_block_y, X
LDY moveable_block_y, X
LDA moveable_block_x, X
TAX
JSR SetTilePushable
    
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
    CMP #$04
    BNE @return
        JSR CHASERENEMYWALK
        LDA #$00
        STA CHASERSPEEDCOUNTER

    JSR UpdateMoveableBlock
@return:
    RTS

DrawGameLoop:
    JSR ANITMATION
    JSR DRAWENEMY
    JSR DRAWCHASERENEMY
    JSR DRAWPLAYER
    ; JSR DrawMoveableBlock
    JSR DrawAllBlocks
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