


ReadController1:
LDA controller1
    STA controller1_prev
    ; Latch
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016
    
    ; Build controller1 by shifting in 8 bits (LSB-first)
    LDA #$00
    STA controller1
    LDY #$08
@read_loop:
    LDA $4016        ; bit0 = current button (1 = pressed)
    LSR A            ; bit0 -> C
    ROR controller1  ; rotate C into controller1
    DEY
    BNE @read_loop
    RTS

    
HandleDpad:

    
    ; --- UP ---
    LDA controller1
    AND #UPBTN
    BEQ @down
    
    LDA #FACINGUP
    STA PLAYERDIRECTION

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @down  
    DEC PLAYER_Y
    
    LDA #$00
    STA is_player_checking
    RTS
    
@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @left

    LDA #FACINGDOWN
    STA PLAYERDIRECTION

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @left
    INC PLAYER_Y
    
    LDA #$00
    STA is_player_checking
    RTS

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @right

    LDA #FACINGLEFT
    STA PLAYERDIRECTION

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @right
    DEC PLAYER_X
    
    LDA #$00
    STA is_player_checking
    RTS

@right:
    ; --- RIGHT ---
    LDA controller1
    AND #RIGHTBTN
    BEQ @start_btn

    LDA #FACINGRIGHT
    STA PLAYERDIRECTION
    
    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @start_btn

    INC PLAYER_X
    LDA #$00
    STA is_player_checking
    
    RTS


@start_btn:
    LDA controller1
    AND #STARTBTN
    BEQ @select_btn
        
        LDA #HitTimer
        STA player_hit_timer
        LDA #$01
        STA is_player_hit
    RTS

@select_btn:
    LDA controller1
    AND #SELECTBTN
    BEQ @a_btn

    RTS

@a_btn:
    LDA controller1
    AND #ABTN
    BEQ @b_btn
        LDA PLAYER_X
        STA bullet_x
        LDA PLAYER_Y
        STA bullet_y
        LDA PLAYERDIRECTION
        STA bullet_direction
        LDA #$01
        STA is_bullet_active
    RTS

@b_btn:
    LDA controller1
    AND #BBTN
    BEQ @done
    
    RTS


@done:
    RTS



LoadPlayerCollisionValues:
    LDA PLAYER_X
    STA collision_check_x
    LDA PLAYER_Y
    STA collision_check_y
    
    LDA PLAYERDIRECTION
    STA collision_check_dir
RTS