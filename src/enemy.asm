
;----------------------Enemy Walk--------------------------------------
EnemyUpdate:


LDA enemy_x
LDA enemy_y

LDA enemy_x+1
LDA enemy_y+1

LDA enemy_x+2
LDA enemy_y+2

LDA is_enemy_active
LDA is_enemy_active+1
LDA is_enemy_active+2

    LDA #$00
    STA enemy_loop_idx
@loop_enemies:
    
    LDX enemy_loop_idx
    CPX enemy_count
    BCS @done


    LDA is_enemy_active, X
    BEQ @advance

    lDA is_bullet_active
    BEQ :+
    JSR BulletVsEnemyOverlap
    :
    LDA enemy_direction, X

    CMP #FACINGUP
    BEQ @move_up

    CMP #FACINGDOWN
    BEQ @move_down
    
    CMP #FACINGLEFT
    BEQ @move_left

    CMP #FACINGRIGHT
    BEQ @move_right
     JMP @advance


@done:
    LDA #$00
    STA enemy_loop_idx
    RTS

 @advance:
    INC enemy_loop_idx
    JMP @loop_enemies



@move_up:
TXA
PHA
TYA
PHA
JSR LoadEnemyCollisionValues   ; OK if uses A only
LDA #$00
STA is_player_checking
JSR TileCollision              ; this will clobber X/Y

PLA
TAY
PLA
TAX
    BCS  @change_direction
    DEC enemy_y, X
     JMP @advance
    
@move_down:
TXA
PHA
TYA
PHA

JSR LoadEnemyCollisionValues   ; OK if uses A only
LDA #$00
STA is_player_checking
JSR TileCollision              ; this will clobber X/Y

PLA
TAY
PLA
TAX
    BCS @change_direction
    INC enemy_y, X
 JMP @advance
@move_left:
TXA
PHA
TYA
PHA
JSR LoadEnemyCollisionValues   ; OK if uses A only
LDA #$00
STA is_player_checking
JSR TileCollision              ; this will clobber X/Y

PLA
TAY
PLA
TAX
    BCS @change_direction
    DEC enemy_x, X
 JMP @advance
@move_right:
TXA
PHA
TYA
PHA
JSR LoadEnemyCollisionValues   ; OK if uses A only
LDA #$00
STA is_player_checking
JSR TileCollision              ; this will clobber X/Y

PLA
TAY
PLA
TAX
    BCS @change_direction
    INC enemy_x, X
 JMP @advance



@change_direction:
    LDX enemy_loop_idx
    LDA enemy_direction, X

    CMP #FACINGUP
    BEQ @push_down

    CMP #FACINGDOWN
    BEQ @push_up
    
    CMP #FACINGLEFT
    BEQ @push_right

    CMP #FACINGRIGHT
    BEQ @push_left

     JMP @advance

@push_up:
    DEC enemy_y, X
    JSR GetRandomDirection
    JMP @advance

@push_down:
    INC enemy_y, X
    JSR GetRandomDirection
    JMP @advance

@push_left:
    DEC enemy_x, X
    JSR GetRandomDirection
    JMP @advance

@push_right:
    INC enemy_x, X
    JSR GetRandomDirection
    JMP @advance


@get_new_direction:
    JMP GetRandomDirection
    
    JMP @advance


GetRandomDirection: 
    LDX enemy_loop_idx
    JSR GetRandom      ; returns random in A
    AND #$03           ; now A = 0,1,2,3
    ASL A              ; shift left ×2
    ASL A              ; ×4
    ASL A              ; ×8
    ASL A              ; ×16
    ASL A              ; ×32  (now A = 0, $20, $40, $60)
    STA enemy_direction, X
    RTS



GetNewEnemyRandomWalkTimer:
    LDX enemy_loop_idx

    LDA enemy_random_walk_timer, X
    CMP #$00
    BNE :+
        JSR GetRandom
        AND #$ff
        STA enemy_random_walk_timer, X
        JSR GetRandomDirection
        RTS
    :
    DEC enemy_random_walk_timer, X
    RTS


LoadEnemyCollisionValues:
    LDX enemy_loop_idx
    LDA enemy_x, X
    STA collision_check_x
    LDA enemy_y, X
    STA collision_check_y
    LDA enemy_direction, X
    STA collision_check_dir
RTS


;----------------------Enemy Draw--------------------------------------
DrawEnemies:
    LDX #$00
@loop_enemies:
    
    CPX enemy_count
    BCS @done

    ; LDA is_enemy_active, X
    ; BEQ @advance
    
    ; --- load this ENEMY's X/Y and precompute x+8,y+8 ---
    LDA enemy_x, X   ; X
    STA tmpx
    CLC
    ADC #8
    STA tmpx8

    LDA enemy_y,X   ; Y
    STA tmpy
    DEC tmpy
    CLC
    ADC #8
    STA tmpy8
    DEC tmpy8
    TXA
    ; --- compute OAM pointer = $0200 + ENEMY_OAM_START    TXA                       ; A = i
    ASL                       ; *2
    ASL                       ; *4
    ASL                       ; *8
    ASL                       ; *16   (16*i)
    CLC
    ADC #(4*ENEMY_OAM_START)  ; + 4*start (sprite index→byte offset)
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
    LDA #ENEMY_TILE_TL        ; tile
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_ATTR           ; attr
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx                  ; X
    STA (oam_ptr_lo),Y
    INY

    ; TR
    LDA tmpy
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_TILE_TR
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    INY

    ; BL
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_TILE_BL
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx
    STA (oam_ptr_lo),Y
    INY

    ; BR
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_TILE_BR
    STA (oam_ptr_lo),Y
    INY
    LDA #ENEMY_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    ; INY not needed after last write

@advance:
    INX
    JMP @loop_enemies          ; (max 255 ENEMYs; you’ll cap earlier)
@done:
    RTS



; IN:  bullet_x, bullet_y, enemy_x, enemy_y (zero-page or RAM bytes)
; OUT: C=1 if overlap, C=0 if no overlap
; TRASH: A
BulletVsEnemyOverlap:
    ; if (bullet_x + 8) <= enemy_x → no hit
    LDX enemy_loop_idx 
    LDA bullet_x
    CLC
    ADC #8
    CMP enemy_x, X
    BCC @no_hit        ; A < enemy_x
    BEQ @no_hit        ; A == enemy_x

    ; if (enemy_x + 16) <= bullet_x → no hit
    LDA enemy_x, X
    CLC
    ADC #16
    CMP bullet_x
    BCC @no_hit        ; A < bullet_x
    BEQ @no_hit        ; A == bullet_x

    ; if (bullet_y + 8) <= enemy_y → no hit
    LDA bullet_y
    CLC
    ADC #8
    CMP enemy_y, X
    BCC @no_hit
    BEQ @no_hit

    ; if (enemy_y + 16) <= bullet_y → no hit
    LDA enemy_y, X
    CLC
    ADC #16
    CMP bullet_y
    BCC @no_hit
    BEQ @no_hit

    ; otherwise they overlap
    JSR Deactivate

    RTS
@no_hit:                 ; C=0 → NO HIT
    RTS


Deactivate:
    LDX enemy_loop_idx
    LDA #$00
    JSR DeactivateBullet
    STA is_enemy_active, X
    LDA #$f0
    STA enemy_y, X
    RTS



LoadEnemies:
    LDX #$00
@loop:
    CPX enemy_count
    BCS @done                ; stop when X >= enemy_count

    TXA                      ; A = X
    ASL                      ; A = 2*X
    TAY                      ; Y = 2*X

    LDA EnemyPos, Y          ; x
    STA enemy_x, X
    INY
    LDA EnemyPos, Y          ; y
    STA enemy_y, X

    INX
    BNE @loop                ; (enemy_count <= 255)
@done:
    RTS


EnemyPos:
    .byte $20, $60
    .byte $60, $60
    .byte $20, $80