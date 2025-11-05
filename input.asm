


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

HandleDpad:

    ; movement speed timer
    LDA move_timer
    BNE @dec
    LDA #50        ; adjust repeat delay
    STA move_timer

    ; --- RIGHT ---
    LDA controller1
    AND #RIGHTBTN
    BEQ @left
    LDA PLAYER_X
    CLC
    ADC PLAYER_W
    STA player_coll_x
    LDA PLAYER_Y
    STA player_coll_y
    JSR TILECollision
    BCS @left
    INC PLAYER_X
    LDA #FACINGRIGHT
    STA direction
    RTS

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @up
    LDA PLAYER_X
    STA player_coll_x
    DEC player_coll_x
    LDA PLAYER_Y
    STA player_coll_y
    JSR TILECollision
    BCS @up
    DEC PLAYER_X
    LDA #FACINGLEFT
    STA direction
    RTS

@up:
    ; --- UP ---
    LDA controller1
    AND #UPBTN
    BEQ @down
    LDA PLAYER_X
    STA player_coll_x
    LDA PLAYER_Y
    STA player_coll_y
    DEC player_coll_y
    JSR TILECollision
    BCS @down    
    LDA #$00
    DEC PLAYER_Y
    LDA #FACINGUP
    STA direction
    RTS

@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @done
    LDA PLAYER_X
    STA player_coll_x
    LDA PLAYER_Y
    CLC
    ADC PLAYER_H
    STA player_coll_y
    JSR TILECollision
    BCS @done
    INC PLAYER_Y
    LDA #FACINGDOWN
    STA direction
    RTS

@done:
    RTS

@dec:
    DEC move_timer
    RTS



