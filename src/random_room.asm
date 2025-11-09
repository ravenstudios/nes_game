RandomCell16x15:
@retry:
    JSR GetRandom          ; A = 0..255
    CMP #$f0
    BCS @retry             ; reject 240..255

    ; A = 0..239
    STA rand_row           ; save for row calc
    AND #$0F               ; low nibble = col
    STA rand_col           ; 0..15
    LDA rand_row

    LSR A                  ; divide by 16 → row 0..14
    LSR A
    LSR A
    LSR A
    STA rand_row
    RTS

LoadRandomRoom:
    LDA #$00
    STA loop_counter
    STA $2001
    LDA #$01
    STA vram_busy
    JSR LOADBACKGROUND
    JSR LoadCollisionTable


    ; JSR RandomCell16x15
    ; LDA rand_col
    ; STA moveable_block_x
    ; LDA rand_row
    ; STA moveable_block_y


; @loop:
    
;     JSR RandomCell16x15

;     LDA #$04
;     STA loadedTile
;     JSR SetTiles
;     JSR SetTileSolid
    
;     INC loop_counter
;     LDA loop_counter

;     CMP #$0A
;     BNE @loop


    LDA #$00
    STA vram_busy
    LDA #%00011110         ; show BG+sprites (set to your mask)
    STA $2001

    LDA $2002
    LDA #$00
    STA $2005
    STA $2005

    RTS




SetTileSolid:
    LDA rand_row
    ASL
    ASL
    ASL
    ASL    
    CLC
    ADC rand_col
    TAX

    LDA #01

    STA COLLISIONTABLE, X

    RTS


SetTiles:
    ; meta (rand_col 0..15, rand_row 0..14) → 8×8 coords
    LDA rand_col
    ASL
    STA tile_x              ; 0..30 (even)
    LDA rand_row
    ASL
    STA tile_y              ; 0..28 (even)

    ; --- row*32 as 16-bit value in tmp0:tmp1 ---
    ; tmp0 = low, tmp1 = high
    LDA tile_y
    STA tmp0
    LDA #$00
    STA tmp1
    ; multiply by 32 → shift left 5 times with carry into high
    ASL tmp0
    ROL tmp1
    ASL tmp0
    ROL tmp1
    ASL tmp0
    ROL tmp1
    ASL tmp0
    ROL tmp1
    ASL tmp0
    ROL tmp1                ; now tmp1:tmp0 = tile_y * 32

    ; add NT base $2000
    CLC
    LDA tmp0
    ADC #<$2000
    STA tmp0
    LDA tmp1
    ADC #>$2000
    STA tmp1

    ; add col (tile_x)
    CLC
    LDA tmp0
    ADC tile_x
    STA tmp0
    LDA tmp1
    ADC #$00
    STA tmp1

    ; --- write TL, TR ---
    LDA $2002
    LDA tmp1
    STA $2006
    LDA tmp0
    STA $2006
    LDA loadedTile
    STA $2007              ; TL
    CLC
    ADC #$01
    STA $2007              ; TR

    ; --- bottom row = base + $20 ---
    CLC
    LDA tmp0
    ADC #$20
    STA tmp0
    LDA tmp1
    ADC #$00
    STA tmp1

    ; write BL, BR
    LDA $2002
    LDA tmp1
    STA $2006
    LDA tmp0
    STA $2006
    LDA loadedTile
    CLC
    ADC #$10
    STA $2007              ; BL
    ADC #$01
    STA $2007              ; BR
    RTS
