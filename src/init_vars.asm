INITVARS:
    LDA #$00
    STA move_timer
    STA anim_timer
    STA anim_frame
    STA vblank_flag
    STA loop_counter
    STA start_screen
    STA state
    STA is_player_hit
    STA frame_counter
    STA player_hit_timer
    STA is_player_checking
    LDA MAX_TIMER
    STA timer_counter
    LDA TIMER_FPS
    STA timer_tick_counter
    STA is_door_unlocked



LDA #(12*16+2)
STA secret_tile


LDA #$00
STA bullet_x
LDA #$f0
STA bullet_y
LDA #$04
STA bullet_w
STA bullet_h
LDA #$00
STA is_bullet_active
STA bullet_direction

LDA #$01
STA is_enemy_active
STA is_enemy_active+1
STA is_enemy_active+2
;     LDX #00
; @l1:
;     STA moveable_block_x, X
;     STA moveable_block_y, X
;     STA is_moveable_block_moved, X
;     INX
;     LDX #01
;     STA moveable_block_x, X
;     STA moveable_block_y, X
;     STA is_moveable_block_moved, X

;     LDX #02
;     STA moveable_block_x, X
;     STA moveable_block_y, X
;     STA is_moveable_block_moved, X

;     LDA #$60
    LDA #03
    STA enemy_count
    STA moveable_block_count
    

    LDX #$00
    LDA #$20
    STA enemy_direction, X

    LDX #$01
    LDA #$40
    STA enemy_direction, X

    LDX #$02
    LDA #$60
    STA enemy_direction, X
    
    LDA #$40
    STA enemy_direction
    LDA #$90
    STA PLAYER_X
    STA PLAYER_Y

    LDA #$10
    STA enemy_random_walk_timer
    STA enemy_random_walk_timer+1
    STA enemy_random_walk_timer+2

    LDA #$80
    ; STA enemy_x
    ; STA enemy_y
    STA CHASERENEMY_X
    STA CHASERENEMY_Y

    

    ; STA direction
    
 
    STA CHASERSPEEDCOUNTER

    LDA #$20
	STA PLAYERDIRECTION
    STA CHASERDIRECTION



    

    RTS