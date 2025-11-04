


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

    JSR TILECollision

    INC PLAYER_X
    LDA #FACINGRIGHT
    STA direction

@left:
    ; --- LEFT ---
    LDA controller1
    AND #LEFTBTN
    BEQ @up

    JSR TILECollision

    DEC PLAYER_X
    LDA #FACINGLEFT
    STA direction

@up:
    ; --- UP ---
    LDA controller1
    AND #UPBTN
    BEQ @down

    JSR TILECollision
    BCS :+
        ; LDA #$01
        ; STA $0020
        ; LDA #$00
        ; STA PLAYER_X
    :
    LDA #$00
    STA $0020
    DEC PLAYER_Y
    LDA #FACINGUP
    STA direction

@down:
    ; --- DOWN ---
    LDA controller1
    AND #DOWNBTN
    BEQ @done

    JSR TILECollision

    INC PLAYER_Y
    LDA #FACINGDOWN
    STA direction

@done:
    RTS

@dec:
    DEC move_timer
    RTS



