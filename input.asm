


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
    ADC PLAYER_SPEED
    ADC #8
    STA NEXT_X
    LDA PLAYER_Y
    STA NEXT_Y
    JSR CheckCollision     ; C=1 if blocked
    BCS @left
    INC PLAYER_X
    LDA #FACINGRIGHT
    STA direction

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @up
    LDA PLAYER_X
    SEC
    SBC PLAYER_SPEED
    SBC #4
    STA NEXT_X
    LDA PLAYER_Y
    STA NEXT_Y
    JSR CheckCollision
    BCS @up
    DEC PLAYER_X
    LDA #FACINGLEFT
    STA direction

@up:
    ; --- UP ---
    LDA controller1
    AND #UPBTN
    BEQ @down
    LDA PLAYER_X
    STA NEXT_X
    LDA PLAYER_Y
    SBC #4
    SBC PLAYER_SPEED
    STA NEXT_Y
    JSR CheckCollision
    BCS @down
    DEC PLAYER_Y
    LDA #FACINGUP
    STA direction

@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @done
    LDA PLAYER_X
    STA NEXT_X
    LDA PLAYER_Y
    CLC
    ADC PLAYER_SPEED
    ADC #8
    STA NEXT_Y
    JSR CheckCollision
    BCS @done
    INC PLAYER_Y
    LDA #FACINGDOWN
    STA direction

@done:
    RTS

@dec:
    DEC move_timer
    RTS



