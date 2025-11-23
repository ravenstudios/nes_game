MoveBlock:
    LDA #$01
    STA is_door_unlocked
    STA door_draw_pending
    STA block_move_pending

@up:
    LDA player_direction
    CMP #FACINGUP
    BNE @down
        LDA movable_block_index
        JSR UnsetTileSolid
        LDA movable_block_index
        JSR Get_x_and_y
        
        
        LDA movable_block_floor_tile_x
        STA movable_block_new_tile_x
        LDA movable_block_floor_tile_y
        SEC
        SBC #$02
        STA movable_block_new_tile_y

        LDA movable_block_index
        SEC
        SBC #$10
        JSR SetTileSolid1
        
        JMP @done

@down:

    LDA player_direction
    CMP #FACINGDOWN
    BNE @left
        LDA movable_block_index
        JSR UnsetTileSolid
        LDA movable_block_index
        JSR Get_x_and_y
        
        
        LDA movable_block_floor_tile_x
        STA movable_block_new_tile_x
        LDA movable_block_floor_tile_y
        CLC
        ADC #$02
        STA movable_block_new_tile_y

        LDA movable_block_index
        CLC
        ADC #$10
        JSR SetTileSolid1
        
        JMP @done

@left:
    LDA player_direction
    CMP #FACINGLEFT
    BNE @right
        LDA movable_block_index
        JSR UnsetTileSolid
        LDA movable_block_index
        JSR Get_x_and_y
        
        
        LDA movable_block_floor_tile_x
        SEC
        SBC #$02
        STA movable_block_new_tile_x
        LDA movable_block_floor_tile_y
        
        STA movable_block_new_tile_y

        LDA movable_block_index
        SEC
        SBC #$01
        JSR SetTileSolid1
        
        JMP @done

@right:
    LDA player_direction
    CMP #FACINGRIGHT
    BNE @done
        LDA movable_block_index
        JSR UnsetTileSolid
        LDA movable_block_index
        JSR Get_x_and_y
        
        
        LDA movable_block_floor_tile_x
        
        CLC
        ADC #$02
        STA movable_block_new_tile_x
        LDA movable_block_floor_tile_y
        STA movable_block_new_tile_y

        LDA movable_block_index
        CLC
        ADC #$01
        JSR SetTileSolid1
        
        JMP @done

@done:
    LDA #$01
    STA block_move_pending
    LDA #$00
    STA block_move_phase  
    RTS




DrawMoveableBlock:

    LDA block_move_pending
    BEQ @done

    LDA block_move_phase
    BEQ @phase0

; ---------- phase 1: draw new block ----------
@phase1:
    ; we’re done after drawing the block
    LDA #$00
    STA block_move_pending

    JSR DrawBlock2x2
    JMP @done

; ---------- phase 0: clear old floor ----------
@phase0:
    LDA #$f4
    STA loadedTile
    JSR Draw2x2_same_tile     ; draws floor tiles

    ; advance to phase 1 for next frame
    LDA #$01
    STA block_move_phase
    JMP @done

@done:
    RTS





Get_x_and_y:
    LDA movable_block_index
    LSR A
    LSR A
    LSR A
    LSR A
    ASL A   
    
    STA movable_block_floor_tile_y   

    LDA movable_block_index
    AND #$0F
    
    ASL A   
    STA movable_block_floor_tile_x 

    RTS



Draw2x2_same_tile:
    ; TL

    LDX movable_block_floor_tile_x
    STX $00d0
    LDY movable_block_floor_tile_y
    STY $00d1

    LDA loadedTile
    JSR SetBGTile

    ; TR
    INX
    LDA loadedTile
    JSR SetBGTile

    ; BL
    DEX
    INY
    LDA loadedTile
    JSR SetBGTile

    ; BR
    INX
    LDA loadedTile
    JSR SetBGTile

    RTS


DrawBlock2x2:
    ; TL
    
    LDX movable_block_new_tile_x
    STX $00d2
    LDY movable_block_new_tile_y
    STY $00d3
    LDA #$04
    STA loadedTile
    JSR SetBGTile

    ; TR
    
    INX
    LDA #$05
    STA loadedTile
    JSR SetBGTile

    ; BL
    
    DEX
    INY
    LDA #$14
    STA loadedTile
    JSR SetBGTile

    ; BR
    
    INX
    LDA #$15
    STA loadedTile
    JSR SetBGTile

    RTS
