DoorData:
    .byte $0d, $0e, $1d, $1e
DoorLocation:
    .word $206C, $206D, $208C, $208D


PPUSTATUS = $2002
PPUADDR   = $2006
PPUDATA   = $2007


DrawDoor:
@vbwait:
    BIT $2002
    BPL @vbwait          ; loop until vblank begins (bit7=1)

LDX #$00
@loop:
    CPX #$08
    BCS @done

    ; Y = X * 2  (byte index into word table)
    TXA
    ASL A
    TAY

    ; Set PPU address from word (write HI then LO)
    LDA PPUSTATUS          ; reset latch
    LDA DoorLocation+1, Y  ; HI byte of address
    STA PPUADDR
    LDA DoorLocation, Y    ; LO byte of address
    STA PPUADDR

    ; Write tile
    LDA DoorData, X
    STA PPUDATA

    INX
    JMP @loop



@done:
    ; Optional: reset scroll to 0,0 if you really need it (not required for VRAM writes)
    LDA #$00
    STA $2005
    STA $2005
    
    LDX #$60
    LDY #$30
    ; JSR SetTileSolid1
    JSR SetTileDoor
    INX
    JSR SetTileDoor

    
    RTS


DoorUpdate:
    LDA is_door_unlocked
    CMP #$01
    BEQ @done
        LDA PLAYER_Y
        LSR
        LSR
        LSR
        LSR         ; A = tile_y
        STA tile_y

        LDA PLAYER_X
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
            JSR DrawDoor

@done:
RTS