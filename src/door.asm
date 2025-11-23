DoorData:
    .byte $0d, $0e, $1d, $1e
DoorLocation:
    .word $208C, $208D, $20aC, $20aD
WallData:
    .byte $4d, $4d, $5d, $5d

PPUSTATUS = $2002
PPUADDR   = $2006
PPUDATA   = $2007


; DoorData was:  $0d, $0e, $1d, $1e
; WallData was:  $4d, $4d, $5d, $5d

; DOOR_TILE_X = 12
; DOOR_TILE_Y = 4

DrawDoor:
    LDA door_draw_pending
    CMP #$01
    BNE @done

    LDA #$00
    STA door_draw_pending ;reset flag

    ; TL
    LDA #$0d
    STA loadedTile
    LDX #DOOR_TILE_X
    LDY #DOOR_TILE_Y
    JSR SetBGTile

    ; TR
    LDA #$0e
    STA loadedTile
    LDX #DOOR_TILE_X+1
    LDY #DOOR_TILE_Y
    JSR SetBGTile

    ; BL
    LDA #$1d
    STA loadedTile
    LDX #DOOR_TILE_X
    LDY #DOOR_TILE_Y+1
    JSR SetBGTile

    ; BR
    LDA #$1e
    STA loadedTile
    LDX #DOOR_TILE_X+1
    LDY #DOOR_TILE_Y+1
    JSR SetBGTile

    ; update collision table for the top row (like you do now)
    LDX #$60       ; pixel X = $60
    LDY #$20       ; pixel Y = $20
    JSR SetTileDoor
    INX
    JSR SetTileDoor
    
@done:
    RTS



Undraw_door:
    LDA can_undraw_door
    CMP #$01
    BNE @done
    LDA #$00
    STA can_undraw_door; reset flag

    ; TL

    LDA #$4d
    STA loadedTile
    LDX #DOOR_TILE_X
    LDY #DOOR_TILE_Y
    JSR SetBGTile

    ; TR
    LDA #$4d
    STA loadedTile
    LDX #DOOR_TILE_X+1
    LDY #DOOR_TILE_Y
    JSR SetBGTile

    ; BL
    LDA #$5d
    STA loadedTile
    LDX #DOOR_TILE_X
    LDY #DOOR_TILE_Y+1
    JSR SetBGTile

    ; BR
    LDA #$5d
    STA loadedTile
    LDX #DOOR_TILE_X+1
    LDY #DOOR_TILE_Y+1
    JSR SetBGTile

    ; update collision table for the top row (like you do now)
    LDX #$60       ; pixel X = $60
    LDY #$20       ; pixel Y = $20
    JSR UnsetTileDoor
    INX
    JSR UnsetTileDoor

    
@done:
    RTS


DoorUpdate:
    LDA is_door_unlocked
    CMP #$01
    BEQ @done
        LDA player_y
        LSR
        LSR
        LSR
        LSR         ; A = tile_y
        STA tile_y

        LDA player_x
        LSR
        LSR
        LSR
        LSR         ; A = tile_x
        STA tile_x

        LDA tile_y
        ASL
        ASL
        ASL
        ASL         ; A = y*16
        CLC
        ADC tile_x


        CMP secret_tile
        BNE @done
            LDA #$01
            STA is_door_unlocked
            STA door_draw_pending
            LDA #$00
            STA can_undraw_door

            ; JSR DrawDoor

@done:
RTS