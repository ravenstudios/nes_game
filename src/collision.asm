;-----------------------Tile Collision------------------------------
TileCollision:

LDA collision_check_dir
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


;all collision_check_vars are loaded before calling this sub routine
@up:
    ;tl
    LDA collision_check_y
    SEC
    SBC #01
    STA collision_check_y
    JSR CheckTile
    BCS @yesCollision
    ;tr
    LDA collision_check_x
    CLC
    ADC #WIDTH
    SEC
    SBC #01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    
    CLC
    RTS

@down:
    ;bl
    LDA collision_check_y
    CLC
    ADC #HEIGHT
    ADC #01
    STA collision_check_y
    JSR CheckTile
    BCS @yesCollision
    ;br
    LDA collision_check_x
    CLC
    ADC #WIDTH
    SEC
    SBC #01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    
    CLC
    RTS

@yesCollision:
    SEC
    RTS

@noCollision:
    CLC
    RTS


@left:
    ;tl
    LDA collision_check_x
    SEC
    SBC #$01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    ;bl
    LDA collision_check_y
    CLC
    ADC #HEIGHT
    SEC
    SBC #01
    STA collision_check_y
    JSR CheckTile
    BCS @yesCollision
    
    CLC
    RTS

@right:
    ;tr
    LDA collision_check_x
    CLC
    ADC #WIDTH
    CLC
    ; ADC #$01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    ;br
    LDA collision_check_y
    CLC
    ADC #HEIGHT
    SEC
    SBC #01
    STA collision_check_y
    JSR CheckTile
    BCS @yesCollision
    
    CLC
    RTS


@done:
    RTS

CheckTile:
    ; x>>4, y>>4 -> index in X (unchanged from your code)
    LDA collision_check_x
    LSR
    LSR
    LSR
    LSR
    STA tile_x

    LDA collision_check_y
    LSR
    LSR
    LSR
    LSR
    STA tile_y

    ; index = y*16 + x  (to X)
    LDA tile_y
    ASL
    ASL
    ASL
    ASL
    CLC
    ADC tile_x
    TAX

    ; --- read tile once and keep it ---
    LDA COLLISIONTABLE, X
    STA cur_tile           ; <- NEW: remember tile value
    STX current_tile_index

    ; ---------- Door (tile = 3) ----------
    LDA cur_tile
    CMP #$03
    BNE :+
        JSR Exit
        CLC                 ; usually treat as passable after teleport
        RTS
:

    ; ---------- Pushable (tile = 2) ----------
    LDA cur_tile
    CMP #$02
    
    BNE @decide_solid       ; not pushable → decide solid/empty below

@up:
    LDA player_direction
    CMP #FACINGUP
    BNE @down
        ;change current tile to floor and convert tiles above to block tile and set solid
        LDA #$6d
        STA loadedTile
        ; LDA cur_tile
        LDA current_tile_index
        JSR UnsetTileSolid
      
        JSR Get_x_and_y ;load cur_tile into A
        ;tl
        LDX tile_x
        LDY tile_y
        
        JSR SetBGTile

        ;tr
        LDX tile_x
        INX
        LDY tile_y
        JSR SetBGTile
        DEX


        ;bl
        LDX tile_x
        LDY tile_y
        INY
        JSR SetBGTile
        DEY

        ;br
        LDX tile_x
        INX
        LDY tile_y
        INY
        JSR SetBGTile
        DEX
        DEY


        ;block
        LDA current_tile_index
        SEC
        SBC #$10
        JSR SetTileSolid1
        DEC tile_y
        DEC tile_y
        LDA #$04
        STA loadedTile
        LDX tile_x
        LDY tile_y
        
        JSR SetBGTile

        ;tr
        LDA #$05
        STA loadedTile
        LDX tile_x
        INX
        LDY tile_y
        JSR SetBGTile
        DEX

        ;bl
        LDA #$14
        STA loadedTile
        LDX tile_x
        LDY tile_y
        INY
        JSR SetBGTile
        DEY

        ;br
        LDA #$15
        STA loadedTile
        LDX tile_x
        INX
        LDY tile_y
        INY
        JSR SetBGTile
        DEX
        DEY


@down:


@decide_solid:
    ; ---------- Final solidity decision from tile value ----------
    LDA cur_tile           ; <- use the cached tile value
    CMP #$01               ; 1 = solid wall?
    BEQ @solid
    CLC                    ; anything else (0=empty, etc.) → no collision
    RTS
@solid:
    SEC
    RTS




; ---- Tile-range overlap on a 16x15 grid -----------------------
; collide_check_1x/1y/1w/1h = box1 (player)
; collide_check_2x/2y/2w/2h = box2 (block)
; Assumes WIDTH/HEIGHT are constants (e.g., 16). For general sizes,
; replace +15 with +(WIDTH-1)/(HEIGHT-1) immediates.
; OUT: C=1 overlap, C=0 no overlap

; temps (ZP recommended)


; assumes WIDTH and HEIGHT are constants for BOTH boxes
; OUT: C=1 overlap, C=0 no overlap
CheckCollision:
    ; box1 X
    LDA collide_check_1x
    LSR
    LSR
    LSR
    LSR
    STA t1_minx
    LDA collide_check_1x
    CLC
    ADC #(WIDTH-1)      ; <-- not hard-coded 15 unless WIDTH=16
    LSR
    LSR
    LSR
    LSR
    STA t1_maxx

    ; box1 Y
    LDA collide_check_1y
    LSR
    LSR
    LSR
    LSR
    STA t1_miny
    LDA collide_check_1y
    CLC
    ADC #(HEIGHT-1)
    LSR
    LSR
    LSR
    LSR
    STA t1_maxy

    ; box2 X
    LDA collide_check_2x
    LSR
    LSR
    LSR
    LSR
    STA t2_minx
    LDA collide_check_2x
    CLC
    ADC #(WIDTH-1)
    LSR
    LSR
    LSR
    LSR
    STA t2_maxx

    ; box2 Y
    LDA collide_check_2y
    LSR
    LSR
    LSR
    LSR
    STA t2_miny
    LDA collide_check_2y
    CLC
    ADC #(HEIGHT-1)
    LSR
    LSR
    LSR
    LSR
    STA t2_maxy

    ; no-overlap tests
    LDA t1_maxx
    CMP t2_minx
    BCC @no_hit

    LDA t2_maxx
    CMP t1_minx
    BCC @no_hit

    LDA t1_maxy
    CMP t2_miny
    BCC @no_hit

    LDA t2_maxy
    CMP t1_miny
    BCC @no_hit

    SEC
    RTS
@no_hit:
    CLC
    RTS

Exit:
    LDA #$60
    STA player_x
    LDA #$e0
    STA player_y
    RTS


Get_x_and_y:
    ; tile_y = index / 16  (row)
    LDA current_tile_index
    STA $0092
    LSR A
    LSR A
    LSR A
    LSR A
    ASL A   
    STA $0091
    STA tile_y          ; 0..14

    ; tile_x = index % 16  (col)
    LDA current_tile_index
    AND #$0F
    STA $0090
    ASL A   
    STA tile_x          ; 0..15

    RTS
