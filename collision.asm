; JMP NoColl

; CheckCollision:
;     ; if NEXT_X + PLAYER_W <= ENEMY_X → no collision
;     LDA NEXT_X
;     CLC
;     ADC #PLAYER_W
;     CMP ENEMY_X      ; ← you had CMP Y (wrong)
;     BCC NoColl

;     ; if ENEMY_X + ENEMY_W <= NEXT_X → no collision
;     LDA ENEMY_X      ; ← you had Y again
;     CLC
;     ADC #ENEMY_W
;     CMP NEXT_X
;     BCC NoColl

;     ; if NEXT_Y + PLAYER_H <= ENEMY_Y → no collision
;     LDA NEXT_Y
;     CLC
;     ADC #PLAYER_H
;     CMP ENEMY_Y
;     BCC NoColl

;     ; if ENEMY_Y + ENEMY_H <= NEXT_Y → no collision
;     LDA ENEMY_Y
;     CLC
;     ADC #ENEMY_H
;     CMP NEXT_Y
;     BCC NoColl

;     ; If we get here → overlap!
;     SEC ;set carry as return True
;     RTS

; NoColl:
;     CLC ;clear carry as
;     ; RTS

TILECollision:
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


    LDA #<COLLISIONTABLEDATA
    CLC
    ADC index_low_byte
    STA index_pointer_low
    LDA #>COLLISIONTABLEDATA
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
