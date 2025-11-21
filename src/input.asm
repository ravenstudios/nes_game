


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
    STA player_direction

    JSR Snap_x

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @down  
    DEC player_y
    
    LDA #$00
    STA is_player_checking
    RTS
    
@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @left

    LDA #FACINGDOWN
    STA player_direction
    JSR Snap_x

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @left
    INC player_y
    
    LDA #$00
    STA is_player_checking
    RTS

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @right

    LDA #FACINGLEFT
    STA player_direction

    JSR Snap_y

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @right
    DEC player_x
    
    LDA #$00
    STA is_player_checking
    RTS

@right:
    ; --- RIGHT ---
    LDA controller1
    AND #RIGHTBTN
    BEQ @start_btn

    LDA #FACINGRIGHT
    STA player_direction
    JSR Snap_y

    JSR LoadPlayerCollisionValues
    LDA #$01
    STA is_player_checking
    JSR TileCollision
    BCS @start_btn

    INC player_x
    LDA #$00
    STA is_player_checking
    
    RTS


@start_btn:
    LDA controller1
    AND #STARTBTN
    BEQ @select_btn
        
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
        LDA player_x
        STA bullet_x
        LDA player_y
        STA bullet_y
        LDA player_direction
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
    LDA player_x
    STA collision_check_x
    LDA player_y
    STA collision_check_y
    
    LDA player_direction
    STA collision_check_dir
RTS







Snap_x:
    LDA player_x
    CLC
    ADC #$04
    LSR A
    LSR A
    LSR A
    STA player_tile_x

   
   LDA player_tile_x
   ASL A
   ASL A
   ASL A
   STA player_x
RTS


Snap_y:
    LDA player_y
    CLC
    ADC #$04
    LSR A
    LSR A
    LSR A
    STA player_tile_y

   
   LDA player_tile_y
   ASL A
   ASL A
   ASL A
   STA player_y
RTS