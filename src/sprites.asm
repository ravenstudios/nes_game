
LOADSPRITES:
    LDX #$00
    LOADSPRITESMEM:
        LDA SPRITEDATA, X
        STA $0200, X
        INX
        CPX #$10	;16bytes (4 bytes per sprite, 8 sprites total)
        BNE LOADSPRITESMEM
        
    RTS

    SPRITEDATA:
    ;   $Y, $SpriteI, $attrs, $X


        ;Player_________________________
        .byte $40, $00, $00, $40
        .byte $40, $01, $00, $48
        .byte $48, $10, $00, $40
        .byte $48, $11, $00, $48
    

        ;     ;bound box
        ; .byte $40, $82, $02, $3f
        ; .byte $40, $83, $02, $47
        ; .byte $48, $92, $02, $3f
        ; .byte $48, $93, $02, $47
        

        ;ENEMY
        ; .byte $80, $08, $2, $80
        ; .byte $80, $09, $2, $88
        ; .byte $88, $18, $2, $80
        ; .byte $88, $19, $2, $88

        ;ENEMY Chaser
        ; .byte $90, $08, $3, $90
        ; .byte $90, $09, $3, $98
        ; .byte $98, $18, $3, $90
        ; .byte $98, $19, $3, $98
        ; ;window
        ; .byte $10, $08, $01, $90
        ; .byte $10, $09, $01, $98
        ; .byte $18, $18, $01, $90
        ; .byte $18, $19, $01, $98
        ; .byte $20, $28, $01, $90
        ; .byte $20, $29, $01, $98
        ; .byte $28, $38, $01, $90
        ; .byte $28, $39, $01, $98
        
        

        ; ; ;Blocks
        ; .byte $60, $82, $00, $60
        ; .byte $60, $83, $00, $68
        ; .byte $68, $92, $00, $60
        ; .byte $68, $93, $00, $68

   

        ; 2 if frames are laid out across, 32 if vertical


    ; ===== TL-only animator, explicit labels =====
    


