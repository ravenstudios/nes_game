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
    ; LDA #$01
    STA is_moveable_block_moved
    STA pushable_contact

    LDA #$60
    STA moveable_block_x
    STA moveable_block_y

    
    LDA #$40
    STA ENEMYDIRECTION
    LDA #$90
    STA PLAYER_X
    STA PLAYER_Y

    LDA #$10
    STA EnemyRandomWalkTimer

    LDA #$80
    STA ENEMY_X
    STA ENEMY_Y
    STA CHASERENEMY_X
    STA CHASERENEMY_Y

    

    ; STA direction
    
 
    STA CHASERSPEEDCOUNTER

    LDA #$20
	STA PLAYERDIRECTION
    STA CHASERDIRECTION


    RTS