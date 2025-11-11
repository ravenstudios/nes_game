


DrawBullet:
; LDA is_bullet_active
;     BEQ @done


    LDA bullet_y        ; Y position on screen (80 decimal)
    STA BULLET_OAM         ; BULLET_OAM[0]

    LDA #BULLET_TILE        ; Tile index (from your CHR)
    STA BULLET_OAM+1       ; BULLET_OAM[1]

    LDA #$00        ; Attributes (palette 0, not flipped)
    STA BULLET_OAM+2       ; BULLET_OAM[2]

    LDA bullet_x        ; X position (80 decimal)
    STA BULLET_OAM+3       ; BULLET_OAM[3]


    @done:
    RTS

UpdateBulet:
    LDA is_bullet_active
    BEQ @done

    JSR BulletHitSolid

    LDA bullet_x
    CMP #$f0 ; offscreen
    BCS DeactivateBullet

    LDA bullet_y
    CMP #$ef ; offscreen
    BCS DeactivateBullet

    LDA is_bullet_active
    BEQ @done
    ;move
    LDA bullet_direction
    CMP #FACINGUP
    BEQ @up
    CMP #FACINGDOWN
    BEQ @down
    CMP #FACINGLEFT
    BEQ @left
    CMP #FACINGRIGHT
    BEQ @right
    @up:
    LDA bullet_y
    SEC
    SBC #BULLET_SPEED
    STA bullet_y
    RTS

    @down:
    LDA bullet_y
    CLC
    ADC #BULLET_SPEED
    STA bullet_y
    RTS

    @left:
    LDA bullet_x
    SEC
    SBC #BULLET_SPEED
    STA bullet_x
    RTS

    @right:
    LDA bullet_x
    CLC
    ADC #BULLET_SPEED
    STA bullet_x
    RTS


@done:
    
    RTS

DeactivateBullet:
    LDA #$F0
    STA bullet_y
    LDA #$00
    STA bullet_x
    STA is_bullet_active
    RTS


; -------------------------------------------------------
; BulletHitSolid
; Checks the tile in front of the bullet (edge midpoint).
; If that tile is non-zero in COLLISIONTABLE → deactivate.
; Uses: A,X. Temps: tmpx,tmpy,tile_x,tile_y
; Expects: bullet_x, bullet_y, bullet_direction
; -------------------------------------------------------
BulletHitSolid:
    LDA is_bullet_active
    BNE :+
        RTS              ; inactive → nothing to do
:
    ; choose probe point (front edge midpoint)
    LDA bullet_direction
    CMP #FACINGRIGHT
    BEQ @probe_right
    CMP #FACINGLEFT
    BEQ @probe_left
    CMP #FACINGDOWN
    BEQ @probe_down
    ; default = up
@probe_up:
    ; x + 4, y - 1
    LDA bullet_x
    CLC
    ADC #4
    STA tmpx
    LDA bullet_y
    SEC
    SBC #1
    STA tmpy
    JMP @to_index

@probe_down:
    ; x + 4, y + 8
    LDA bullet_x
    CLC
    ADC #4
    STA tmpx
    LDA bullet_y
    CLC
    ADC #8
    STA tmpy
    JMP @to_index

@probe_left:
    ; x - 1, y + 4
    LDA bullet_x
    SEC
    SBC #1
    STA tmpx
    LDA bullet_y
    CLC
    ADC #4
    STA tmpy
    JMP @to_index

@probe_right:
    ; x + 8, y + 4
    LDA bullet_x
    CLC
    ADC #8
    STA tmpx
    LDA bullet_y
    CLC
    ADC #4
    STA tmpy
    ; fallthrough

@to_index:
    ; tile_x = tmpx >> 4 ; tile_y = tmpy >> 4
    LDA tmpx
    LSR
    LSR
    LSR
    LSR
    STA tile_x

    LDA tmpy
    LSR
    LSR
    LSR
    LSR
    STA tile_y

    ; X = tile_y*16 + tile_x
    LDA tile_y
    ASL
    ASL
    ASL
    ASL              ; *16
    CLC
    ADC tile_x
    TAX

    ; nonzero = blocked/solid (treat 1 and 2 as solid)
    LDA COLLISIONTABLE, X
    BEQ @clear
    ; hit something → deactivate bullet
    JSR DeactivateBullet
@clear:
    RTS

