INITVARS:
    LDA #$00
    STA move_timer
    STA anim_timer
    STA anim_frame
    STA vblank_flag

    LDA #$40
    STA PLAYER_X
    STA PLAYER_Y
    LDA #$10
    STA PLAYER_W
    STA PLAYER_H
    STA ENEMY_W
    STA ENEMY_H

    LDA #$00
    STA ENEMY_X
    STA ENEMY_Y

    STA direction
    LDA #$00
	STA direction
    RTS