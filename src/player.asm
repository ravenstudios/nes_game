DRAWPLAYER:
    ; JSR DrawHealth
	LDA anim_frame
    ASL A
    CLC
    ADC player_direction
    TAX                        ; X = frame_base

    ;load next sprite for animation
    STX $0201                  ; TL
    INX
    STX $0205                  ; TR
    TXA
    CLC
    ADC #15
    TAX
    STX $0209                  ; BL
    INX
    STX $020D                  ; BR    

    LDA player_x
    STA $0203
    STA $020b
    CLC
    ADC #8
    STA $0207
    STA $020f

    LDA player_y
    STA player_y_pos

    ; decide blink
    LDA frame_counter
    AND #%00000001         ; test bit 0 (odd/even frame)
    BNE @hide               ; odd → hide

@show:
    ; top row Y = player_y_pos - 1  (NES OAM Y is spriteY+1)
    LDA player_y_pos
    SEC
    SBC #$01
    STA $0200              ; TL Y
    STA $0204              ; TR Y
    CLC
    ADC #8                 ; bottom row Y = top + 8
    STA $0208              ; BL Y
    STA $020C              ; BR Y
    JMP @done

@hide:
    LDA is_player_hit
    BEQ @show
    LDA #$FE
    STA $0200
    STA $0204
    STA $0208
    STA $020C

@done:
    RTS


UpdatePlayer:
    LDA player_health
    BNE :+
        JSR Gameover
    :

    LDX #$00
    @loop:
    CPX enemy_count
    BEQ @done
        LDA enemy_y, X
        LSR
        LSR
        LSR
        LSR         ; A = tile_y
        STA tile_y

        LDA enemy_x, X
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
        STA tmp_tile
        
        JSR GetPlayerTile
        LDA tmp_tile
        CMP player_tile
        BNE @next
            LDA is_player_hit
            BNE @next
            LDA #HitTimer
            STA player_hit_timer
            LDA #$01
            STA is_player_hit
            DEC player_health
            STA can_draw_health
            ; JSR UpdateHealth


    @next:
        INX
        JMP @loop

@done:
RTS



GetPlayerTile:
    LDA player_y
    LSR
    LSR
    LSR
    LSR         ; A = tile_y
    STA player_tile_y

    LDA player_x
    LSR
    LSR
    LSR
    LSR         ; A = tile_x
    STA player_tile_x

    LDA player_tile_y
    ASL
    ASL
    ASL
    ASL         ; A = y*16
    CLC
    ADC player_tile_x
    STA player_tile

    RTS


DrawHealth:

    ; Only draw when flagged
    ; LDA can_draw_health
    ; CMP #$01
    ; BNE @done

    ; LDA #$00
    ; STA can_draw_health

    ; Clamp player_health to MAX_HEALTH just in case
    LDA player_health
    CMP #MAX_HEALTH
    BCC :+
        LDA #MAX_HEALTH
        STA player_health
    :

    ; --- set PPU address to start of health bar ---
    LDA PPUSTATUS          ; $2002, reset latch
    LDA #HEALTH_ADDR_HI
    STA PPUADDR            ; $2006 high
    LDA #HEALTH_ADDR_LO
    STA PPUADDR            ; $2006 low

    ; --- draw MAX_HEALTH tiles in a row ---
    LDX #$00               ; heart index

@health_loop:
    CPX #MAX_HEALTH
    BCS @done_write

    ; choose tile: heart if X < player_health, else blank
    CPX player_health
    BCC @heart_tile

@blank_tile:
    LDA #$00               ; blank tile index
    BEQ @emit              ; always taken

@heart_tile:
    LDA #HEALTH_TILE       ; heart tile index

@emit:
    STA PPUDATA            ; $2007

    INX
    JMP @health_loop

@done_write:
@done:

	LDA #$00
    STA $2005
    STA $2005
    RTS





PlayerHitTimer:
    ; --- hit flash timer (safe, no underflow) ---
    LDA is_player_hit
    BEQ @done                ; not active → skip

    LDA player_hit_timer
    BEQ @clear               ; already 0 → clear & stop

    DEC player_hit_timer     ; count down once per frame
    LDA player_hit_timer
    
    BNE @done                ; still >0 → done

@clear:
    LDA #$00
    STA is_player_hit
    STA player_hit_timer     ; keep it at 0

@done:
    RTS






LoadPlayer:
    LDX #$00
    @loop:
        LDA PlayerSpriteData, X
        STA $0200, X
        INX
        CPX #$10	;16bytes (4 bytes per sprite, 8 sprites total)
        BNE @loop
        
    RTS

    PlayerSpriteData:
    ;   $Y, $SpriteI, $attrs, $X


        ;Player_________________________
        .byte PLAYER_Y_START, $00, $00, PLAYER_X_START
        .byte PLAYER_Y_START, $01, $00, (PLAYER_X_START+8)
        .byte (PLAYER_Y_START+8), $10, $00, PLAYER_X_START
        .byte (PLAYER_Y_START+8), $11, $00, (PLAYER_X_START+8)




