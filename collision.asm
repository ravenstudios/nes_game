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


tl: .res 1
tr: .res 1
bl: .res 1
br: .res 1
tile_x: .res 1
tile_y: .res 1
tile_i: .res 1

TILECollision:
    ;tl
    LDA PLAYER_X
    LSR 
    LSR
    LSR
    STA tile_x
    STA $0040 ;tile x
    LDA PLAYER_Y
    STA $0026
    LSR 
    LSR
    LSR
    STA tile_y
    STA $0041 ;tile y

    LDA tile_y
    STA $0021 ;debug
    ASL A
    ASL A
    ASL A
    ASL A
    ASL A
    CLC
    STA $0042 ;tile y
    CLC
    ADC tile_x
    STA tile_i
    LDX tile_i
    LDA COLLISIONTABLE, X
    STX $0022 ;debug
    BEQ @returntrue
        CLC
        RTS
    
    @returntrue:
    SEC
    RTS
; Pick the points to check on the player.
; Use the four corners of the player’s box:

; Top-left (x, y)

; Top-right (x+width−1, y)

; Bottom-left (x, y+height−1)

; Bottom-right (x+width−1, y+height−1)

; Convert each point from pixels → tile coordinates.
; Since each tile is 8×8:

; tile_x = floor(point_x / 8)

; tile_y = floor(point_y / 8)