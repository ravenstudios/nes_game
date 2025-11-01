


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
    ; Only move when timer expires
    LDA move_timer
    BNE @dec_timer      ; if > 0, skip moving
    LDA #50            ; <-- adjust this value
    STA move_timer      ; reset delay

    ; RIGHT
    LDA controller1
    AND #RIGHTBTN
    BEQ @check_left
    INC XPOS

@check_left:
    ; LEFT
    LDA controller1
    AND #LEFTBTN
    BEQ @check_up
    DEC XPOS

@check_up:
    ; UP
    LDA controller1
    AND #UPBTN
    BEQ @check_down
    DEC YPOS

@check_down:
    ; DOWN
    LDA controller1
    AND #DOWNBTN
    BEQ @done
    INC YPOS


@done:
    RTS

@dec_timer:
    DEC move_timer
    RTS
