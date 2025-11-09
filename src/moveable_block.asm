
; DrawMoveableBlock:

;     ; write X
;     LDA moveable_block_x
 
;     STA $0233
;     STA $023b
;     CLC
;     ADC #8
;     STA $0237
;     STA $023f

;     ; write Y
;     LDA moveable_block_y

;     SEC 
;     SBC #$01
;     STA $0230
;     STA $0234
;     CLC
;     ADC #8
;     STA $0238
;     STA $023c

;     RTS

; Writes all pushable blocks as 2x2 metasprites.
; Uses 4 sprites per block, so OAM moves in 16-byte steps.
DrawAllBlocks:
    LDX #$00
@loop_blocks:
    CPX moveable_block_count
    BCS @done

    ; --- load this block's X/Y and precompute x+8,y+8 ---
    LDA moveable_block_x,X   ; X
    STA tmpx
    CLC
    ADC #8
    STA tmpx8

    LDA moveable_block_y,X   ; Y
    STA tmpy
    CLC
    ADC #8
    STA tmpy8

    ; --- compute OAM pointer = $0200 + 16*(BLOCK_OAM_START + X) ---
    TXA                       ; A = i
    ASL                       ; *2
    ASL                       ; *4
    ASL                       ; *8
    ASL                       ; *16   (16*i)
    CLC
    ADC #(4*BLOCK_OAM_START)  ; + 4*start (sprite index→byte offset)
    CLC
    ADC #$00                  ; low of $0200
    STA oam_ptr_lo
    LDA #$02                  ; high of $0200
    ADC #$00                  ; carry won’t happen here, but keeps symmetry
    STA oam_ptr_hi

    ; --- write 4 sprites (Y,tile,attr,X) using (oam_ptr),Y ---
    LDY #0

    ; TL
    LDA tmpy                  ; Y
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_TL        ; tile
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR           ; attr
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx                  ; X
    STA (oam_ptr_lo),Y
    INY

    ; TR
    LDA tmpy
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_TR
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    INY

    ; BL
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_BL
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx
    STA (oam_ptr_lo),Y
    INY

    ; BR
    LDA tmpy8
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_TILE_BR
    STA (oam_ptr_lo),Y
    INY
    LDA #BLOCK_ATTR
    STA (oam_ptr_lo),Y
    INY
    LDA tmpx8
    STA (oam_ptr_lo),Y
    ; INY not needed after last write

    INX
    BNE @loop_blocks          ; (max 255 blocks; you’ll cap earlier)
@done:
    RTS


UpdateMoveableBlock:
LDX #$00
@loop_blocks:
    CPX moveable_block_count
    BCS @done

    LDA is_moveable_block_moved, X
    BEQ @next_block

    ;set curent tile to passable
    TXA
    PHA
    LDY moveable_block_y, X
    LDA moveable_block_x, X
    TAX
    JSR UnsetTileSolid
    PLA
    TAX
    ;move block
    LDA PLAYERDIRECTION

    CMP #FACINGUP
    BEQ @up

    CMP #FACINGDOWN
    BEQ @down

    CMP #FACINGLEFT
    BEQ @left

    CMP #FACINGRIGHT
    BEQ @right
    CLC
    RTS

@up:
LDA moveable_block_y, X
SEC
SBC #$10
STA moveable_block_y, X
JMP @next

@down:
LDA moveable_block_y, X
CLC
ADC #$10
STA moveable_block_y, X
JMP @next

@left:
LDA moveable_block_x, X
SEC
SBC #$10
STA moveable_block_x, X
JMP @next

@right:
LDA moveable_block_x, X
CLC
ADC #$10
STA moveable_block_x, X
JMP @next

@next:
;set new tile solid
LDY moveable_block_y, X
TXA
PHA
LDA moveable_block_x, X
TAX
JSR SetTileSolid1
PLA
TAX
LDA #$00
STA is_moveable_block_moved, X


@next_block:
    INX
    BNE @loop_blocks

@done:
RTS


; LoadCollisionValues:
;     ;obj 1 self
;     ;obj 2 player
;     LDA moveable_block_x
;     STA collision_check_x
;     LDA moveable_block_y
;     STA collision_check_y

;     RTS