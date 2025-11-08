TILECollision:

LDA collision_check_dir
CMP #FACINGUP
BEQ @up

CMP #FACINGDOWN
BEQ @down

CMP #FACINGLEFT
BEQ @left

CMP #FACINGRIGHT
BEQ @rightjmp

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
    ADC collision_check_w
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
    ADC collision_check_h
    ADC #01
    STA collision_check_y
    JSR CheckTile
    BCS @yesCollision
    ;br
    LDA collision_check_x
    CLC
    ADC collision_check_w
    SEC
    SBC #01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    
    CLC
    RTS


@rightjmp:
    JMP @right

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
    ADC collision_check_h
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
    ADC collision_check_w
    CLC
    ; ADC #$01
    STA collision_check_x
    JSR CheckTile
    BCS @yesCollision
    ;br
    LDA collision_check_y
    CLC
    ADC collision_check_h
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
    LDA collision_check_x
    LSR 
    LSR
    LSR
    STA tile_x
    
    LDA collision_check_y
    LSR 
    LSR
    LSR
    STA tile_y
    STA index_low_byte
    LDA #$00
    STA index_high_byte



    LDA index_low_byte
    ASL index_low_byte
    ROL index_high_byte
    ASL index_low_byte
    ROL index_high_byte
    ASL index_low_byte
    ROL index_high_byte
    ASL index_low_byte
    ROL index_high_byte
    ASL index_low_byte
    ROL index_high_byte

    CLC
    LDA index_low_byte
    ADC tile_x
    STA index_low_byte
    LDA index_high_byte
    ADC #$00
    STA index_high_byte


    LDA #<COLLISIONTABLE
    CLC
    ADC index_low_byte
    STA index_pointer_low
    LDA #>COLLISIONTABLE
    ADC index_high_byte
    STA index_pointer_high

    LDY #0
    LDA (index_pointer_low),Y

    CMP #$01
    BNE @return_true
        SEC
        RTS
@return_true:
    CLC
    RTS


; returns Z=0 (not equal) if collision happens
; returns Z=1 if no collision

; AABB overlap test using unsigned math (8-bit)
; Inputs: collide_check_1x,1y,1w,1h and collide_check_2x,2y,2w,2h
; Output: C=1 (hit), C=0 (no hit). A/X/Y unchanged (if you need, push/pop).

; collide_check_1x/1y/1w/1h  = box 1 (player)
; collide_check_2x/2y/2w/2h  = box 2 (block)
; OUT: C=1 collision, C=0 no collision

CheckCollision:
    ; if (x2 + w2) <= x1 → no hit
    LDA collide_check_2x
    CLC
    ADC collide_check_2w
    CMP collide_check_1x
    BCC @no_hit       ; A <  M  → no hit
    BEQ @no_hit       ; A == M  → no hit

    ; if (x1 + w1) <= x2 → no hit
    LDA collide_check_1x
    CLC
    ADC collide_check_1w
    CMP collide_check_2x
    BCC @no_hit
    BEQ @no_hit

    ; if (y2 + h2) <= y1 → no hit
    LDA collide_check_2y
    CLC
    ADC collide_check_2h
    CMP collide_check_1y
    BCC @no_hit
    BEQ @no_hit

    ; if (y1 + h1) <= y2 → no hit
    LDA collide_check_1y
    CLC
    ADC collide_check_1h
    CMP collide_check_2y
    BCC @no_hit
    BEQ @no_hit

    ; overlap on both axes → hit
    SEC
    RTS
@no_hit:
    CLC
    RTS




