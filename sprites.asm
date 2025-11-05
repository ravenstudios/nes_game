
LOADSPRITES:
    LDX #$00
    LOADSPRITESMEM:
        LDA SPRITEDATA, X
        STA $0200, X
        INX
        CPX #$20	;16bytes (4 bytes per sprite, 8 sprites total)
        BNE LOADSPRITESMEM
        
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
        ;Player_________________________
        .byte $40, $00, $00, $40
        .byte $40, $01, $00, $48
        .byte $48, $10, $00, $40
        .byte $48, $11, $00, $48

        ;ENEMY
        .byte $80, $08, $2, $80
        .byte $80, $09, $2, $88
        .byte $88, $18, $2, $80
        .byte $88, $19, $2, $88
        ; ;window
        ; .byte $10, $08, $01, $90
        ; .byte $10, $09, $01, $98
        ; .byte $18, $18, $01, $90
        ; .byte $18, $19, $01, $98
        ; .byte $20, $28, $01, $90
        ; .byte $20, $29, $01, $98
        ; .byte $28, $38, $01, $90
        ; .byte $28, $39, $01, $98
        
        

        ; ;Blocks
        ; .byte $90, $80, $00, $60
        ; .byte $90, $81, $00, $68
        ; .byte $98, $90, $00, $60
        ; .byte $98, $91, $00, $68

        ; 2 if frames are laid out across, 32 if vertical


    ; ===== TL-only animator, explicit labels =====
    


