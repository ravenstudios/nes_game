

EnemyWalk:
INC $0070
    ; JSR GetRandomDirection
    ; STA enemy_direction
    STA $0090
    LDA enemy_direction

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
    JSR LoadEnemyCollisionValues
    JSR TileCollision
    BCS @change_direction ;will be move random
    DEC enemy_y
    RTS
    
@move_down:
INC $0081
    JSR LoadEnemyCollisionValues
    JSR TileCollision
    BCS @change_direction
    INC enemy_y 
    RTS

@move_left:
INC $0082
    JSR LoadEnemyCollisionValues
    JSR TileCollision
    BCS @change_direction
    DEC enemy_x 
    RTS

@move_right:
INC $0083
    JSR LoadEnemyCollisionValues
    JSR TileCollision
    BCS @change_direction
    INC enemy_x
    RTS


@change_direction:
INC $0084
    LDA enemy_direction

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
    DEC enemy_y
    JMP @get_new_direction
    RTS

@push_down:
    INC enemy_y
    JMP @get_new_direction
    RTS

@push_left:
    DEC enemy_x
    JMP @get_new_direction
    RTS

@push_right:
    INC enemy_x
    JMP @get_new_direction
    RTS


@get_new_direction:
    JMP GetRandomDirection
    
    RTS

LDY #$00
; DRAWENEMY:

; @loop:

; 	LDA anim_frame
;     ASL A
;     CLC
;     ADC #$08
;     ADC enemy_direction, Y
;     TAX                        ; X = frame_base
    
;     ; write TILE bytes ONLY
;     STX $0211                  ; TL
;     INX
;     STX $0215                  ; TR
;     TXA
;     CLC
;     ADC #15
;     TAX
;     STX $0219               ; BL
;     INX
;     STX $021d               ; BR    

    
    

;         ; write X
;     LDA enemy_x
;     STA $0213
;     STA $021b
;     CLC
;     ADC #8
;     STA $0217
;     STA $021f

;     ; write Y
;     LDA enemy_y
;     SEC 
;     SBC #$01
;     STA $0210
;     STA $0214
;     CLC
;     ADC #8
;     STA $0218
;     STA $021c

;     RTS

DrawEnemies:
    LDX #$00
@loop_enemies:
    CPX enemy_count
    BCS @done

    ; --- load this block's X/Y and precompute x+8,y+8 ---
    LDA enemy_x,X   ; X
    STA tmpx
    CLC
    ADC #8
    STA tmpx8

    LDA enemy_y,X   ; Y
    STA tmpy
    CLC
    ADC #8
    STA tmpy8

    ; --- compute OAM pointer = $0200 + 16*(BLOCK_OAM_START + X) ---
    TXA                       ; A = i
    ASL                       ; *2
    ASL                       ; *4
    ASL                       ; *8
    ASL                       ; *16   (16*i)
    CLC
    ADC #(4*BLOCK_OAM_START)  ; + 4*start (sprite index→byte offset)
    CLC
    ADC #$00                  ; low of $0200
    STA oam_ptr_lo
    LDA #$02                  ; high of $0200
    ADC #$00                  ; carry won’t happen here, but keeps symmetry
    STA oam_ptr_hi

    ; --- write 4 sprites (Y,tile,attr,X) using (oam_ptr),Y ---
    LDY #0

    ; TL
    LDA tmpy                  ; Y
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_TL        ; tile
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR           ; attr
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx                  ; X
    STA (oam_ptr_lo),Y
    INY

    ; TR
    LDA tmpy
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_TR
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    INY

    ; BL
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_BL
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx
    STA (oam_ptr_lo),Y
    INY

    ; BR
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_BR
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    ; INY not needed after last write

    INX
    BNE @loop_enemies          ; (max 255 blocks; you’ll cap earlier)
@done:
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
    STA enemy_direction
    RTS



GetNewEnemyRandomWalkTimer:
INC $0087
    LDA enemy_random_walk_timer
    CMP #$00
    BNE :+
        JSR GetRandom
        AND #$ff
        STA enemy_random_walk_timer
        JSR GetRandomDirection
        RTS
    :
    DEC enemy_random_walk_timer
    RTS


LoadEnemyCollisionValues:
INC $0088
    LDA enemy_x
    STA collision_check_x
    LDA enemy_y
    STA collision_check_y
    LDA enemy_direction
    STA collision_check_dir
RTS
