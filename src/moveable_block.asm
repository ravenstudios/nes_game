
DrawMoveableBlock:

    ; write X
    LDA moveable_block_x
 
    STA $0233
    STA $023b
    CLC
    ADC #8
    STA $0237
    STA $023f

    ; write Y
    LDA moveable_block_y

    SEC 
    SBC #$01
    STA $0230
    STA $0234
    CLC
    ADC #8
    STA $0238
    STA $023c

    RTS


UpdateMoveableBlock:
 LDA pushable_contact
 BEQ @done
    LDA #$20
    STA moveable_block_x
    STA moveable_block_y
    STA pushable_contact

@done:
RTS


LoadCollisionValues:
    ;obj 1 self
    ;obj 2 player
    LDA moveable_block_x
    STA collision_check_x
    LDA moveable_block_y
    STA collision_check_y

    RTS