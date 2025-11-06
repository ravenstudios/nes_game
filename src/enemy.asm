




ENEMYWALK:
INC $0070
    ; JSR GetRandomDirection
    ; STA ENEMYDIRECTION
    STA $0090
    LDA ENEMYDIRECTION

    CMP #FACINGUP
    BEQ @move_up

    CMP #FACINGDOWN
    BEQ @move_down
    
    CMP #FACINGLEFT
    BEQ @move_left

    CMP #FACINGRIGHT
    BEQ @move_right
    RTS


@move_up:
    INC $0080
    JSR LoadENEMYCollisionValues
    JSR TILECollision
    BCS @change_direction ;will be move random
    DEC ENEMY_Y
    RTS
    
@move_down:
INC $0081
    JSR LoadENEMYCollisionValues
    JSR TILECollision
    BCS @change_direction
    INC ENEMY_Y 
    RTS

@move_left:
INC $0082
    JSR LoadENEMYCollisionValues
    JSR TILECollision
    BCS @change_direction
    DEC ENEMY_X 
    RTS

@move_right:
INC $0083
    JSR LoadENEMYCollisionValues
    JSR TILECollision
    BCS @change_direction
    INC ENEMY_X
    RTS


@change_direction:
INC $0084
    LDA ENEMYDIRECTION

    CMP #FACINGUP
    BEQ @push_down

    CMP #FACINGDOWN
    BEQ @push_up
    
    CMP #FACINGLEFT
    BEQ @push_right

    CMP #FACINGRIGHT
    BEQ @push_left

    RTS

@push_up:
    DEC ENEMY_Y
    JMP @get_new_direction
    RTS

@push_down:
    INC ENEMY_Y
    JMP @get_new_direction
    RTS

@push_left:
    DEC ENEMY_X
    JMP @get_new_direction
    RTS

@push_right:
    INC ENEMY_X
    JMP @get_new_direction
    RTS


@get_new_direction:
    JMP GetRandomDirection
    
    RTS

DRAWENEMY:
INC $0085
	LDA anim_frame
    ASL A
    CLC
    ADC #$08
    ADC ENEMYDIRECTION
    TAX                        ; X = frame_base
    
    ; write TILE bytes ONLY
    STX $0211                  ; TL
    INX
    STX $0215                  ; TR
    TXA
    CLC
    ADC #15
    TAX
    STX $0219               ; BL
    INX
    STX $021d               ; BR    

    
    

        ; write X
    LDA ENEMY_X
    STA $0213
    STA $021b
    CLC
    ADC #8
    STA $0217
    STA $021f

    ; write Y
    LDA ENEMY_Y
    SEC 
    SBC #$01
    STA $0210
    STA $0214
    CLC
    ADC #8
    STA $0218
    STA $021c

    RTS


GetRandomDirection:
INC $0086
    JSR GetRandom      ; returns random in A
    AND #$03           ; now A = 0,1,2,3
    ASL A              ; shift left ×2
    ASL A              ; ×4
    ASL A              ; ×8
    ASL A              ; ×16
    ASL A              ; ×32  (now A = 0, $20, $40, $60)
    STA ENEMYDIRECTION
    RTS



GetNewEnemyRandomWalkTimer:
INC $0087
    LDA EnemyRandomWalkTimer
    CMP #$00
    BNE :+
        JSR GetRandom
        AND #$ff
        STA EnemyRandomWalkTimer
        JSR GetRandomDirection
        RTS
    :
    DEC EnemyRandomWalkTimer
    RTS


LoadENEMYCollisionValues:
INC $0088
    LDA ENEMY_X
    STA collision_check_x
    LDA ENEMY_Y
    STA collision_check_y
    LDA ENEMY_W
    STA collision_check_w
    LDA ENEMY_H
    STA collision_check_h
    LDA ENEMYDIRECTION
    STA collision_check_dir
RTS
