.include "levels.asm"


; ===== LoadLevel: sets bgPtr + collPtr based on current level, then loads data =====

LoadLevel:
    ; turn rendering OFF while we touch VRAM
    LDA #$00
    STA $2001

    ; A or memory "level" holds the current level index (0-based)
    LDA level        ; 0,1,2,...
    ASL A            ; *2
    ASL A            ; *4  (4 bytes per entry)
    TAX              ; X = offset into LevelTable

    ; --- bgPtr = pointer to this level's BG data ---
    LDA LevelTable, X     ; BG low
    STA bgPtrLo
    INX
    LDA LevelTable, X     ; BG high
    STA bgPtrHi
    INX

    ; --- collPtr = pointer to this level's collision data ---
    LDA LevelTable, X     ; COLL low
    STA collPtrLo
    INX
    LDA LevelTable, X     ; COLL high
    STA collPtrHi

    ; now we have pointers for this level
    JSR LoadCollisionTable
    JSR LoadBackground
    JSR LoadBKAtr

    LDA #$01
    STA can_draw_health
    ; JSR UpdateHealth
    LDA level
    CMP #$00
    BNE :+
        JSR Level_1_init
        JMP @done
    
    :
    LDA level
    CMP #$01
    BNE :+
        JSR Level_2_init
        JMP @done
    
    :
    LDA level
    CMP #$02
    BNE :+
        JSR Level_3_init
        JMP @done
    :
    LDA level
    CMP #$03
    BNE :+
        JSR Level_4_init
        JMP @done
    :

    @done:
    ; turn rendering back ON
    LDA #%00011110
    STA $2001

    RTS



; ===== LoadBackground: copy 1024 bytes from ROM → PPU nametable $2000 =====

LoadBackground:
    ; set PPU address to $2000 (nametable 0)
    LDA $2002          ; reset latch
    LDA #$20
    STA $2006
    LDA #$00
    STA $2006

    ; copy bgPtr into tempPtr so we don't modify bgPtr itself
    LDA bgPtrLo
    STA tempPtrLo
    LDA bgPtrHi
    STA tempPtrHi

    ; --- 3 full pages (3 * 256 = 768 bytes) ---
    LDY #$00
    LDX #$03           ; 3 pages

@page_loop:
@byte_loop:
    LDA (tempPtrLo), Y
    STA $2007
    INY
    BNE @byte_loop     ; when Y wraps, page done

    INC tempPtrHi      ; move to next 256-byte page
    DEX
    BNE @page_loop

    ; --- last 192 bytes (960 - 768 = 192) ---
    LDY #$00
@last_chunk:
    CPY #192           ; $C0
    BEQ @done_bg
    LDA (tempPtrLo), Y
    STA $2007
    INY
    BNE @last_chunk

@done_bg:
    ; reset scroll
    LDA #$00
    STA $2005
    STA $2005

    RTS


;LOAD BACKGROUND PALETTEDATA
	

LoadBKAtr:
    LDA #$23	
	STA $2006
	LDA #$c0
	STA $2006
	LDX #$00
    @loop:
	LDA BKAttrTableData, X
	STA $2007
	INX
	CPX #$40
	BNE @loop

	;RESET SCROLL
	LDA #$00
	STA $2005
	STA $2005
RTS


BKAttrTableData:
    .byte $ff, $ff, $ff, $ff, $ff, $ff, $ff, $ff
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00
	.byte $00, $00, $00, $00, $00, $00, $00, $00



LoadCollisionTable:
    LDY #$00
@copy:
    CPY #240            ; 16*15
    BEQ @done
    LDA (collPtrLo), Y  ; read from current level's collision data
    STA COLLISIONTABLE, Y
    INY
    BNE @copy
@done:
    RTS



UpdateMapLoader:
    ; Level 3 only
    LDA level
    CMP #$02
    BNE @done

    ; wait until all 3 enemies are dead
    LDA enemy_kill_count
    CMP #$03
    BNE @done

    ; already unlocked? then do nothing (avoid re-drawing each frame)
    LDA is_door_unlocked
    BNE @done

    ; first time: mark unlocked & draw door once
    LDA #$01
    STA is_door_unlocked
    STA door_draw_pending
    ; JSR DrawDoor

@done:
    RTS

















