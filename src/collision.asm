TILECollision:

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
    INC $00a1
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
    ; x >> 4
    LDA collision_check_x
    LSR
    LSR
    LSR
    LSR
    STA tile_x

    ; y >> 4
    LDA collision_check_y
    LSR
    LSR
    LSR
    LSR
    STA tile_y

    ; index = y*16 + x
    LDA tile_y
    ASL
    ASL
    ASL
    ASL              ; <<4 (KEEP THIS IN A)
    CLC
    ADC tile_x
    TAX


    
    ;if current tile == 2 - pushable block
        
    LDA COLLISIONTABLE,X
    CMP #02
    BNE @done
        LDY moveable_block_count
        DEY ; -1 for array 
        ;loop through all pushblocks
        @loop:
            TYA
            BEQ @done 
            ;compare current push block x with collision_check_x
            LDA moveable_block_x, Y
            CMP collision_check_x
            BEQ  :+
                JMP @next_block

            :
            ;compare current  push block y
            LDA moveable_block_y, Y
            CMP collision_check_y
            BEQ @set_flag
                JMP @next_block

    ; if same then set pushable_contact[x] to #$01
    @set_flag:
        LDA #$01
        STA pushable_contact, Y
        JMP @done
    ;if not iny, loop
    @next_block:
        DEY
        JMP @loop
        
@done:
    CMP #$01
    BEQ @solid
    CLC
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
