INITVARS:
    LDA #$00
    STA move_timer
    STA anim_timer
    STA anim_frame
    STA vblank_flag
    STA loop_counter

    
    LDA #$40
    STA ENEMYDIRECTION
    LDA #$90
    STA PLAYER_X
    STA PLAYER_Y
    LDA #$10
    STA PLAYER_W
    STA PLAYER_H
    STA ENEMY_W
    STA ENEMY_H
    STA CHASERENEMY_W
    STA CHASERENEMY_H
    STA EnemyRandomWalkTimer
    LDA #$80
    STA ENEMY_X
    STA ENEMY_Y
    STA CHASERENEMY_X
    STA CHASERENEMY_Y

    

    ; STA direction
    
    STA PLAYERMOVED
    STA CHASERSPEEDCOUNTER

    LDA #$20
	STA PLAYERDIRECTION
    STA CHASERDIRECTION
    LDA #$A5       ; any non-zero seed
    STA rand8

    RTS