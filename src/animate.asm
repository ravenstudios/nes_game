 ; timer
 ANITMATION:
    INC anim_timer
    LDA anim_timer
    CMP #ANIM_SPEED
    BCC @pass            ; < speed? don’t advance frame

    ; advance frame
    LDA #0
    STA anim_timer
    LDA anim_frame
    CLC
    ADC #1
    CMP #NUM_FRAMES
    BCC @store_frame
    LDA #0
@store_frame:
    STA anim_frame
@pass:
    RTS