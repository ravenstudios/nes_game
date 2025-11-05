


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
   
    ; --- RIGHT ---
    LDA controller1
    AND #RIGHTBTN
    BEQ @left
    LDA PLAYER_X
    CLC
    ADC PLAYER_W
    STA collision_check_x
    LDA PLAYER_Y
    STA collision_check_y
    JSR TILECollision
    BCS @left
    INC PLAYER_X
    LDA #FACINGRIGHT
    STA PLAYERDIRECTION
    RTS

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @up
    LDA PLAYER_X
    STA collision_check_x
    DEC collision_check_x
    LDA PLAYER_Y
    STA collision_check_y
    JSR TILECollision
    BCS @up
    DEC PLAYER_X
    LDA #FACINGLEFT
    STA PLAYERDIRECTION
    RTS

@up:
    ; --- UP ---
    LDA controller1
    AND #UPBTN
    BEQ @down
    LDA PLAYER_X
    STA collision_check_x
    LDA PLAYER_Y
    STA collision_check_y
    DEC collision_check_y
    JSR TILECollision
    BCS @down    
    LDA #$00
    DEC PLAYER_Y
    LDA #FACINGUP
    STA PLAYERDIRECTION
    RTS

@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @done
    LDA PLAYER_X
    STA collision_check_x
    LDA PLAYER_Y
    CLC
    ADC PLAYER_H
    STA collision_check_y
    JSR TILECollision
    BCS @done
    INC PLAYER_Y
    LDA #FACINGDOWN
    STA PLAYERDIRECTION
    RTS

@done:
    RTS




