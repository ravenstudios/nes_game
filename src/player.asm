DRAWPLAYER:
	LDA anim_frame
    ASL A
    CLC
    ADC PLAYERDIRECTION
    TAX                        ; X = frame_base

    ;load next sprite for animation
    STX $0201                  ; TL
    INX
    STX $0205                  ; TR
    TXA
    CLC
    ADC #15
    TAX
    STX $0209                  ; BL
    INX
    STX $020D                  ; BR    

    ;bounding box for test
    ; LDA #$80
    ; STA $0201                  ; TL
    ; LDA #$81
    ; STA $0205                  ; TR
    ; LDA #$90
    ; STA $0209                  ; BL
    ; LDA #$91
    ; STA $020D                  ; BR    

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
    SEC
    SBC #$01
    STA $0200
    STA $0204
    CLC
    ADC #8
    STA $0208
    STA $020c

    
    RTS