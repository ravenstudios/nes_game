
MimicUpdate:

@up:
    LDA controller1
    AND #UPBTN
    BEQ @down
        JSR LoadMimicCollisionValues   ; OK if uses A only
        JSR TileCollision 
        BCS @done
            JSR MimicSnap_x
            INC mimic_y
            JMP @done
@down:
    LDA controller1
    AND #DOWNBTN
    BEQ @right
        JSR LoadMimicCollisionValues   ; OK if uses A only
        JSR TileCollision 
        BCS @done 
            JSR MimicSnap_x
            DEC mimic_y
            JMP @done
@right:
    LDA controller1
    AND #RIGHTBTN
    BEQ @left
        JSR LoadMimicCollisionValues   ; OK if uses A only
        JSR TileCollision 
        BCS @done 
            JSR MimicSnap_y
            DEC mimic_x
            JMP @done

@left:
    LDA controller1
    AND #LEFTBTN
    BEQ @done
        JSR LoadMimicCollisionValues   ; OK if uses A only
        JSR TileCollision 
        BCS @done 
            JSR MimicSnap_y
            INC mimic_x
            JMP @done
@done:
RTS
DrawMimic:
     

    ; top row Y
    LDA mimic_y
    STA MIMIC_OAM_BASE+0    ; sprite 0 Y (TL)
    STA MIMIC_OAM_BASE+4    ; sprite 1 Y (TR)

    ; bottom row Y = MIMIC_Y + 8
   
    ADC #8
    STA MIMIC_OAM_BASE+8    ; sprite 2 Y (BL)
    STA MIMIC_OAM_BASE+12   ; sprite 3 Y (BR)

    ; --- tile indices ---
    JSR GetDirection
    LDA anim_frame
    ASL A
    CLC
    
    ADC mimic_direction
    TAX 
   
    
                    
    STX MIMIC_OAM_BASE+1 ; TL tile
    INX    
    STX MIMIC_OAM_BASE+5 ; TR tile
    TXA
    CLC
    ADC #$0f
    TAX
    STX MIMIC_OAM_BASE+9 ; BL tile
    INX              
    STX MIMIC_OAM_BASE+13 ; BR tile

    ; --- attributes (palette, priority, flips) ---

    LDA #$01                ; pick your attr
    STA MIMIC_OAM_BASE+2    ; TL
    STA MIMIC_OAM_BASE+6    ; TR
    STA MIMIC_OAM_BASE+10   ; BL
    STA MIMIC_OAM_BASE+14   ; BR

    ; --- X positions ---

    ; left column X
    LDA mimic_x
    STA MIMIC_OAM_BASE+3    ; sprite 0 X (TL)
    STA MIMIC_OAM_BASE+11   ; sprite 2 X (BL)

    ; right column X = MIMIC_X + 8
    CLC
    ADC #8
    STA MIMIC_OAM_BASE+7    ; sprite 1 X (TR)
    STA MIMIC_OAM_BASE+15   ; sprite 3 X (BR)

    RTS

GetDirection:
LDA player_direction
@up:
CMP #FACINGUP
BNE @down
    LDA #FACINGDOWN
    STA mimic_direction
    JMP @done

@down:
CMP #FACINGDOWN
BNE @right
    LDA #FACINGUP
    STA mimic_direction
    JMP @done

@right:
CMP #FACINGRIGHT
BNE @left
    LDA #FACINGLEFT
    STA mimic_direction
    JMP @done

@left:
CMP #FACINGLEFT
BNE @done
    LDA #FACINGRIGHT
    STA mimic_direction
    JMP @done


@done:
RTS



LoadMimicCollisionValues:
    LDA mimic_x
    STA collision_check_x
    LDA mimic_y
    STA collision_check_y
    LDA mimic_direction
    STA collision_check_dir
RTS



;*******************LOAD MIMIC**************************
LoadMimic:
    LDX #$00
@loop:
    LDA MimicSpriteData, X
    STA $0200 + 4*MIMIC_OAM_START, X   ; write into OAM buffer
    INX
    CPX #$10        ; 16 bytes
    BNE @loop
    RTS

MimicSpriteData:
    .byte $f0, $00, $01, $40
    .byte $f0, $01, $01, $48
    .byte $f0, $10, $01, $40
    .byte $f0, $11, $01, $48





MimicSnap_x:
    LDA mimic_x
    CLC
    ADC #$04
    LSR A
    LSR A
    LSR A
    STA mimic_tile_x

   
   LDA mimic_tile_x
   ASL A
   ASL A
   ASL A
   STA mimic_x
RTS


MimicSnap_y:
    LDA mimic_y
    CLC
    ADC #$04
    LSR A
    LSR A
    LSR A
    STA mimic_tile_y

   
   LDA mimic_tile_y
   ASL A
   ASL A
   ASL A
   STA mimic_y
RTS