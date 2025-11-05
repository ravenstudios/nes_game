DRAWPLAYER:
	LDA anim_frame
    ASL A
    CLC
    ADC PLAYERDIRECTION
    TAX                        ; X = frame_base

    ; write TILE bytes ONLY
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

    
    RTS