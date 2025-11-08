RandomCell16x15:
@retry:
    JSR GetRandom          ; A = 0..255
    CMP #$f0
    BCS @retry             ; reject 240..255

    ; A = 0..239
    STA rand_row           ; save for row calc
    AND #$0F               ; low nibble = col
    STA rand_col           ; 0..15
    STA $0040
    LDA rand_row

    LSR A                  ; divide by 16 → row 0..14
    LSR A
    LSR A
    LSR A
    STA rand_row
    STA $0041
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


@loop:
    
    JSR RandomCell16x15

    LDA #$04
    STA loadedTile
    JSR SetTiles
    JSR SetTileSolid
    
    INC loop_counter
    LDA loop_counter

    CMP #$0A
    BNE @loop



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
    
    ; meta (0..15,0..14) -> 8x8 tile coords (0..30,0..28) even
    LDA rand_col
    ASL
    STA tile_x
    LDA rand_row
    ASL
    STA tile_y

    ; index = tile_y * 32  (16-bit: index_high_byte:index_low_byte)
    LDA tile_y
    STA index_low_byte
    LDA #$00
    STA index_high_byte

    ASL index_low_byte   ; *2
    ROL index_high_byte
    ASL index_low_byte   ; *4
    ROL index_high_byte
    ASL index_low_byte   ; *8
    ROL index_high_byte
    ASL index_low_byte   ; *16
    ROL index_high_byte
    ASL index_low_byte   ; *32
    ROL index_high_byte

    ; index += tile_x
    CLC
    LDA index_low_byte
    ADC tile_x
    STA index_low_byte
    LDA index_high_byte
    ADC #$00
    STA index_high_byte

    ; pointer = COLLISIONTABLE + index
    LDA #<COLLISIONTABLE
    CLC
    ADC index_low_byte
    STA index_pointer_low
    LDA #>COLLISIONTABLE
    ADC index_high_byte
    STA index_pointer_high

    ; write 1 to the 4 cells: (x,y), (x+1,y), (x,y+1), (x+1,y+1)
    LDY #$00
    LDA #$01
    STA (index_pointer_low),Y       ; (x,y)
    INY
    STA (index_pointer_low),Y       ; (x+1,y)

    ; ptr += 32 (next row)
    CLC
    LDA index_pointer_low
    ADC #$20
    STA index_pointer_low
    LDA index_pointer_high
    ADC #$00
    STA index_pointer_high

    LDY #$00
    LDA #$01
    STA (index_pointer_low),Y       ; (x,y+1)
    INY
    STA (index_pointer_low),Y       ; (x+1,y+1)

    RTS



; ------------------------------------------------------------
; WriteRandTileToNT
; Inputs:
;   A = tile id to write
;   rand_col = 0..31
;   rand_row = 0..29
; Nametable base = $2000 (change hi/lo if you use another)
; Clobbers: A, X, Y, tmp0, tmp1
; ------------------------------------------------------------
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
