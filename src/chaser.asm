




CHASERENEMYWALK:
    ; -------- HORIZONTAL --------
    LDA PLAYER_X
    CMP CHASERENEMY_X
    BEQ @VERT                   ; same column → skip horizontal

    BCC @GO_LEFT                ; player_x < enemy_x → go left

    ; go RIGHT
    LDA #FACINGRIGHT
    STA CHASERENEMYDIRECTION
    JSR LoadChaserCollisionValues
    JSR TILECollision
    BCS @bump_left                ; blocked → skip move
    INC CHASERENEMY_X
    JMP @VERT

@bump_left:
    DEC CHASERENEMY_X
    JMP @VERT


@GO_LEFT:
    LDA #FACINGLEFT
    STA CHASERENEMYDIRECTION
    JSR LoadChaserCollisionValues
    JSR TILECollision
    BCS @bump_right
    DEC CHASERENEMY_X
    JMP @VERT


@bump_right:
    INC CHASERENEMY_X
    JMP @VERT
@VERT:
    ; -------- VERTICAL --------
    LDA PLAYER_Y
    CMP CHASERENEMY_Y
    BEQ @DONE                   ; same row → skip vertical

    BCC @GO_UP                  ; player_y < enemy_y → go up

    ; go DOWN
    LDA #FACINGDOWN
    STA CHASERENEMYDIRECTION
    JSR LoadChaserCollisionValues
    JSR TILECollision
    BCS @bump_up
    INC CHASERENEMY_Y
    JMP @DONE

@bump_up:
    DEC CHASERENEMY_Y
    JMP @DONE

@GO_UP:
    LDA #FACINGUP
    STA CHASERENEMYDIRECTION
    JSR LoadChaserCollisionValues
    JSR TILECollision
    BCS @bump_down
    DEC CHASERENEMY_Y
    JMP @DONE

@bump_down:
    INC CHASERENEMY_Y
    JMP @DONE

    
@DONE:
    RTS


DRAWCHASERENEMY:

	LDA anim_frame
    ASL A
    CLC
    ADC #$08
    ADC ENEMYDIRECTION
    TAX                        ; X = frame_base
    
    ; write TILE bytes ONLY
    STX $0221                  ; TL
    INX
    STX $0225                  ; TR
    TXA
    CLC
    ADC #15
    TAX
    STX $0229               ; BL
    INX
    STX $022d               ; BR    

    
    

        ; write X
    LDA CHASERENEMY_X
    STA $0223
    STA $022b
    CLC
    ADC #8
    STA $0227
    STA $022f

    ; write Y
    LDA CHASERENEMY_Y
    STA $0220
    STA $0224
    CLC
    ADC #8
    STA $0228
    STA $022c

    RTS



LoadChaserCollisionValues:
INC $0088
    LDA CHASERENEMY_X
    STA collision_check_x
    LDA CHASERENEMY_Y
    STA collision_check_y
    LDA CHASERENEMY_W
    STA collision_check_w
    LDA CHASERENEMY_H
    STA collision_check_h
    LDA CHASERDIRECTION
    STA collision_check_dir
RTS
