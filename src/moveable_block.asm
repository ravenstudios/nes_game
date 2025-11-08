
DrawMoveableBlock:
    ; write X
    LDA moveable_block_x
    STA $00
    STA $0233
    STA $023b
    CLC
    ADC #8
    STA $0237
    STA $023f

    ; write Y
    LDA moveable_block_y

    SEC 
    SBC #$01
    STA $0230
    STA $0234
    CLC
    ADC #8
    STA $0238
    STA $023c

    RTS


UpdateMoveableBlock:

    JSR LoadCollisionValues
    JSR CheckCollision
    BCC @done          ; C=0 → no hit → skip
    ; on collision:
        LDA PLAYERDIRECTION

        CMP #FACINGUP
        BNE :+
            LDA PLAYER_Y
            SEC
            SBC moveable_block_h
            STA moveable_block_y
            JMP @done
        :
        CMP #FACINGDOWN
        BNE :+
            LDA PLAYER_Y
            CLC
            ADC moveable_block_h
            STA moveable_block_y
            JMP @done
        :
        CMP #FACINGLEFT
        BNE :+
            LDA PLAYER_X
            SEC
            SBC moveable_block_w
            STA moveable_block_x
            JMP @done
        :
        CMP #FACINGRIGHT
        BNE :+
            LDA PLAYER_X
            CLC
            ADC moveable_block_w
            STA moveable_block_x
            JMP @done
        :
@done:
RTS


LoadCollisionValues:
    ;obj 1 self
    ;obj 2 player
    LDA moveable_block_x
    STA collide_check_1x
    LDA moveable_block_y
    STA collide_check_1y
    LDA moveable_block_w
    STA collide_check_1w
    LDA moveable_block_h
    STA collide_check_1h

    LDA PLAYER_X
    STA collide_check_2x
    LDA PLAYER_Y
    STA collide_check_2y
    LDA PLAYER_W
    STA collide_check_2w
    LDA PLAYER_H
    STA collide_check_2h

    RTS