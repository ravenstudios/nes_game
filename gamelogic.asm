.include "input.asm"





INFLOOP:
    JSR ReadController1

    LDA PLAYER_X
    CMP #LEFTBOUNDS
    BCC CLAMPLEFT            ; PLAYER_X < LEFT  -> clamp left
    CMP #RIGHTBOUNDS
    BCS CLAMPRIGHT           ; PLAYER_X >= RIGHT -> clamp right
    JMP XOK

CLAMPLEFT:
    LDA #LEFTBOUNDS
    STA PLAYER_X
    JMP XOK

CLAMPRIGHT:
    LDA #RIGHTBOUNDS
    STA PLAYER_X
    JMP XOK

XOK:

LDA PLAYER_Y
CMP #TOPBOUNDS
BCC CLAMPTOP
CMP #BOTTOMBOUNDS
BCS CLAMPBOTTOM
JMP YOK

CLAMPTOP:
    LDA #TOPBOUNDS
    STA PLAYER_Y
    JMP YOK

CLAMPBOTTOM:
    LDA #BOTTOMBOUNDS
    STA PLAYER_Y
    JMP YOK

YOK:

    ; write X
    LDA PLAYER_X
    STA $0203
    STA $020b
    CLC
    ADC #8
    STA $0207
    STA $020f

    ; write Y
    LDA PLAYER_Y
    STA $0200
    STA $0204
    CLC
    ADC #8
    STA $0208
    STA $020c

    LDA #$60
    STA ENEMY_X
    LDA #$90
    STA ENEMY_Y
    ; JSR CheckCollision
    ; BCS FIXLOCATION
    ; JMP DONEFIXLOCATION

; FIXLOCATION:


;     LDA direction
;     CMP #FACINGUP
;     BNE @checkdown
;     CLC
;     LDA ENEMY_Y
;     ADC ENEMY_H
;     ADC #$01
;     STA PLAYER_Y
;     JMP DONEFIXLOCATION

; @checkdown:
;     LDA direction
;     CMP #FACINGDOWN
;     BNE @checkleft
;     LDA ENEMY_Y
;     CLC
;     SBC PLAYER_H
;     SBC #$01
;     STA PLAYER_Y
;     JMP DONEFIXLOCATION

; @checkleft:
;     LDA direction
;     CMP #FACINGLEFT
;     BNE @checkright
;     LDY ENEMY_X
;     DEX
;     STY PLAYER_X
;     JMP DONEFIXLOCATION

; @checkright:
;     LDA direction
;     CMP #FACINGRIGHT
;     BNE DONEFIXLOCATION
;     LDA ENEMY_X
;     CLC
;     ADC ENEMY_W
;     ADC #$01
;     STA PLAYER_X
    


; DONEFIXLOCATION:




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