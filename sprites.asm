
LOADSPRITES:
    LDX #$00
    LOADSPRITESMEM:
        LDA SPRITEDATA, X
        STA $0200, X
        INX
        CPX #$50	;16bytes (4 bytes per sprite, 8 sprites total)
        BNE LOADSPRITESMEM
        ; JMP DONE
    RTS

    SPRITEDATA:
    ;   $Y, $SpriteI, $attrs, $X

    ;Y, SPRITE NUM, attributes, X
    ;76543210
    ;||||||||
    ;||||||++- Palette (4 to 7) of sprite
    ;|||+++--- Unimplemented
    ;||+------ Priority (0: in front of background; 1: behind background)
    ;|+------- Flip sprite horizontally
    ;+-------- Flip sprite vertically

        .byte $40, $00, $00, $40
        .byte $40, $01, $00, $48
        .byte $48, $10, $00, $40
        .byte $48, $11, $00, $48

        ;window
        .byte $10, $08, $01, $90
        .byte $10, $09, $01, $98
        .byte $18, $18, $01, $90
        .byte $18, $19, $01, $98
        .byte $20, $28, $01, $90
        .byte $20, $29, $01, $98
        .byte $28, $38, $01, $90
        .byte $28, $39, $01, $98
        
        

        ;Blocks
        .byte $90, $80, $00, $60
        .byte $90, $81, $00, $68
        .byte $98, $90, $00, $60
        .byte $98, $91, $00, $68

        ; 2 if frames are laid out across, 32 if vertical


    ; ===== TL-only animator, explicit labels =====
    

AnimatePlayer:
   
    LDA vblank_flag
    BEQ @ret
    LDA #0
    STA vblank_flag
    
    ; timer
    INC anim_timer
    LDA anim_timer
    CMP #ANIM_SPEED
    BCC @write_only            ; < speed? don’t advance frame

    ; advance frame
    LDA #0
    STA anim_timer
    LDA anim_frame
    CLC
    ADC #1
    CMP #NUM_FRAMES
    BCC @store_frame
    LDA #0
@store_frame:
    STA anim_frame

@write_only:
	LDA anim_frame
    ASL A
    CLC
    ADC direction
	STA $0030
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




@ret:
    RTS


DONE:

