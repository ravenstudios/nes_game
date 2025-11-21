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

    LDA level
    CMP #$00
    BNE :+
        JSR Level_1_init
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
  .byte $00, $00, $00, $00, $00, $00, $00, $00
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




; LOADBACKGROUND:

; 	LDA $2002		;read PPU status to reset high/low latch
; 	LDA #$20	;start of nametable "canvas" as the high bit
; 	STA $2006	
; 	LDA #$00	;sets low bit
; 	STA $2006	;what adress to write to starting at $2100
; 	LDX #$00	;bad code that uses wraparound to hit 0 in the loop
; LOADBACKGROUNDP1:
; 	LDA BACKGROUNDDATA, X ;loop through BACKGROUNDDATA
; 	STA $2007 ; store byte
; 	LDA COLLISIONTABLEDATA, X
; 	; STA COLLISIONTABLE
; 	INX
; 	CPX #$00 ;wrap around
; 	BNE LOADBACKGROUNDP1 ; if x == 0 break
; LOADBACKGROUNDP2:
; 	LDA BACKGROUNDDATA+256, X
; 	STA $2007
; 	LDA COLLISIONTABLEDATA+256, X
; 	; STA COLLISIONTABLE
; 	INX
; 	CPX #$00
; 	BNE LOADBACKGROUNDP2
; LOADBACKGROUNDP3:
; 	LDA BACKGROUNDDATA+512, X
; 	STA $2007
; 	LDA COLLISIONTABLEDATA+512, X
; 	; STA COLLISIONTABLE
; 	INX
; 	CPX #$00
; 	BNE LOADBACKGROUNDP3
; LOADBACKGROUNDP4:
; 	LDA BACKGROUNDDATA+768, X
; 	STA $2007
; 	LDA COLLISIONTABLEDATA+768, X
; 	; STA COLLISIONTABLE
; 	INX
; 	CPX #$c0
; 	BNE LOADBACKGROUNDP4
; ;192

; ;LOAD BACKGROUND PALETTEDATA
; 	LDA #$23	
; 	STA $2006
; 	LDA #$c0
; 	STA $2006
; 	LDX #$00
; LOADBACKGROUNDATTRDATA:
; 	LDA BACKGROUNDATTRDATA, X
; 	STA $2007
; 	INX
; 	CPX #$40
; 	BNE LOADBACKGROUNDATTRDATA

; 	;RESET SCROLL
; 	LDA #$00
; 	STA $2005
; 	STA $2005



; RTS
















