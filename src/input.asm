


ReadController1:
    ; Latch controller
    LDA #$01
    STA $4016
    LDA #$00
    STA $4016

    ; Build controller1 by shifting in 8 bits
    LDA #$00
    STA controller1
    LDY #$08
@read_loop:
    LDA $4016        ; bit0 = current button (1 = pressed)
    LSR A            ; move bit0 -> C
    ROR controller1  ; rotate C into controller1 (LSB first)
   
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
    JSR TILECollision
    BCS @down  
    DEC PLAYER_Y
    
    RTS
    
@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @left

    LDA #FACINGDOWN
    STA PLAYERDIRECTION

    JSR LoadPlayerCollisionValues
    JSR TILECollision
    BCS @left
    INC PLAYER_Y
    
    RTS

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @right

    LDA #FACINGLEFT
    STA PLAYERDIRECTION

    JSR LoadPlayerCollisionValues
    JSR TILECollision
    BCS @right
    DEC PLAYER_X
    
    RTS

@right:
    ; --- RIGHT ---
    LDA controller1
    AND #RIGHTBTN
    BEQ @done

    LDA #FACINGRIGHT
    STA PLAYERDIRECTION
    
    JSR LoadPlayerCollisionValues
    JSR TILECollision
    BCS @done

    INC PLAYER_X
    
    RTS

@done:
    RTS



LoadPlayerCollisionValues:
    LDA PLAYER_X
    STA collision_check_x
    LDA PLAYER_Y
    STA collision_check_y
    LDA PLAYER_W
    STA collision_check_w
    LDA PLAYER_H
    STA collision_check_h
    LDA PLAYERDIRECTION
    STA collision_check_dir
RTS