.include "input.asm"





INFLOOP:
    JSR ReadController1

    LDA XPOS
    CMP #LEFTBOUNDS
    BCC CLAMPLEFT            ; XPOS < LEFT  -> clamp left
    CMP #RIGHTBOUNDS
    BCS CLAMPRIGHT           ; XPOS >= RIGHT -> clamp right
    JMP XOK

CLAMPLEFT:
    LDA #LEFTBOUNDS
    STA XPOS
    JMP XOK

CLAMPRIGHT:
    LDA #RIGHTBOUNDS
    STA XPOS
    JMP XOK

XOK:

LDA YPOS
CMP #TOPBOUNDS
BCC CLAMPTOP
CMP #BOTTOMBOUNDS
BCS CLAMPBOTTOM
JMP YOK

CLAMPTOP:
    LDA #TOPBOUNDS
    STA YPOS
    JMP YOK

CLAMPBOTTOM:
    LDA #BOTTOMBOUNDS
    STA YPOS
    JMP YOK

YOK:

    ; write X
    LDA XPOS
    STA $0203
    STA $020b
    CLC
    ADC #8
    STA $0207
    STA $020f

    ; write Y
    LDA YPOS
    STA $0200
    STA $0204
    CLC
    ADC #8
    STA $0208
    STA $020c

    JSR AnimatePlayer

	JMP INFLOOP


NMI:
    PHA
    TXA
    PHA
    TYA
    PHA

    LDA #1
    STA vblank_flag
    
    ;Draw
    LDA #$02
    STA $4014

    PLA
    TAY
    PLA
    TAX
    PLA
    RTI