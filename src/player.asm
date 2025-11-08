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

    ; ; write Y
    ; LDA PLAYER_Y
    ; SEC
    ; SBC #$01
    ; STA $0200
    ; STA $0204
    ; CLC
    ; ADC #8
    ; STA $0208
    ; STA $020c

    ; assume: PLAYER_Y is the logical position (0..$EF)
; OAM: TL=$0200, TR=$0204, BL=$0208, BR=$020C

    ; cache player Y for this frame
    LDA PLAYER_Y
    STA player_y_pos

    ; decide blink
    LDA frame_counter
    AND #%00000001         ; test bit 0 (odd/even frame)
    BNE @hide               ; odd → hide

@show:
    ; top row Y = player_y_pos - 1  (NES OAM Y is spriteY+1)
    LDA player_y_pos
    SEC
    SBC #$01
    STA $0200              ; TL Y
    STA $0204              ; TR Y
    CLC
    ADC #8                 ; bottom row Y = top + 8
    STA $0208              ; BL Y
    STA $020C              ; BR Y
    JMP @done

@hide:
    ; put metasprite offscreen (any Y >= $F0 hides); $FE is common
    LDA is_player_hit
    BEQ @show
    LDA #$FE
    STA $0200
    STA $0204
    STA $0208
    STA $020C

@done:
    ; (write X and tile/attr as usual elsewhere)



    
    RTS