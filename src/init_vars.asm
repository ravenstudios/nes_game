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

    
    LDA #$40
    STA enemy_direction
    LDA #$90
    STA PLAYER_X
    STA PLAYER_Y

    LDA #$10
    STA enemy_random_walk_timer

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


    LDA #$03
    STA moveable_block_count
    RTS