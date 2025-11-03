JMP NoColl

CheckCollision:
    ; if NEXT_X + PLAYER_W <= ENEMY_X → no collision
    LDA NEXT_X
    CLC
    ADC #PLAYER_W
    CMP ENEMY_X      ; ← you had CMP Y (wrong)
    BCC NoColl

    ; if ENEMY_X + ENEMY_W <= NEXT_X → no collision
    LDA ENEMY_X      ; ← you had Y again
    CLC
    ADC #ENEMY_W
    CMP NEXT_X
    BCC NoColl

    ; if NEXT_Y + PLAYER_H <= ENEMY_Y → no collision
    LDA NEXT_Y
    CLC
    ADC #PLAYER_H
    CMP ENEMY_Y
    BCC NoColl

    ; if ENEMY_Y + ENEMY_H <= NEXT_Y → no collision
    LDA ENEMY_Y
    CLC
    ADC #ENEMY_H
    CMP NEXT_Y
    BCC NoColl

    ; If we get here → overlap!
    SEC ;set carry as return True
    RTS

NoColl:
    CLC ;clear carry as
    ; RTS

