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
