DRAWPLAYER:
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

    ;bounding box for test
    ; LDA #$80
    ; STA $0201                  ; TL
    ; LDA #$81
    ; STA $0205                  ; TR
    ; LDA #$90
    ; STA $0209                  ; BL
    ; LDA #$91
    ; STA $020D                  ; BR    

    ; write X
    LDA player_x
    STA $0203
    STA $020b
    CLC
    ADC #8
    STA $0207
    STA $020f

    ; ; write Y
    ; LDA PLAYER_Y
    ; SEC
    ; SBC #$01
    ; STA $0200
    ; STA $0204
    ; CLC
    ; ADC #8
    ; STA $0208
    ; STA $020c

    ; assume: PLAYER_Y is the logical position (0..$EF)
; OAM: TL=$0200, TR=$0204, BL=$0208, BR=$020C

    ; cache player Y for this frame
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
    ; put metasprite offscreen (any Y >= $F0 hides); $FE is common
    LDA is_player_hit
    BEQ @show
    LDA #$FE
    STA $0200
    STA $0204
    STA $0208
    STA $020C

@done:
    ; (write X and tile/attr as usual elsewhere)



    
    RTS

; enemy_x: .res 3
; enemy_y: .res 3
; enemy_direction: .res 3
; enemy_random_walk_timer: .res 3
; is_enemy_active: .res 3
; enemy_count: .res 1


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
            JSR UpdateHealth


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





; draws a row of hearts starting at HEALTH_X, row HEALTH_Y
; heart if i < player_health, else blank

UpdateHealth:
    LDX #$00
    LDA #HEALTH_X         ; base X (tile column)
    STA tmp               ; tmp holds current draw X

@health_loop:
    CPX #MAX_HEALTH
    BCS @health_done      ; exit if X >= MAX_HEALTH

    ; --- choose tile: heart if X < player_health, else blank ---
    CPX player_health
    BCC @draw_heart       ; X < player_health → heart
@draw_blank:
    LDA #$00              ; blank tile (adjust as needed)
    STA loadedTile
    JMP @emit
@draw_heart:
    LDA #HEALTH_TILE
    STA loadedTile

@emit:
    ; preserve loop index, use tmp as draw X for SetBGTile
    TXA
    PHA

    LDX tmp               ; draw column
    LDY #HEALTH_Y         ; draw row
    JSR SetBGTile

    PLA
    TAX                   ; restore loop index

    ; advance draw X and loop index
    LDA tmp
    CLC
    ADC #1
    STA tmp
    INX
    JMP @health_loop

@health_done:
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




