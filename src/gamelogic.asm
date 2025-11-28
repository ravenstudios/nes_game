.include "player.asm"
.include "input.asm"
.include "enemy.asm"
.include "chaser.asm"
.include "animate.asm"
.include "moveable_block.asm"
.include "bullet.asm"
.include "timer.asm"
.include "door.asm"
.include "gameover.asm"
.include "map_loader.asm"
.include "mimic.asm"
; .include "audio.asm"
.include "ShiftyTestTheme.asm"


INFLOOP:

@wait_vblank:
    LDA vblank_flag
    BEQ @wait_vblank
    LDA #0
    STA vblank_flag

    INC frame_counter

    ; ===== handle transition phase 2: actually load the new room =====
    LDA transition_phase
    CMP #$02
    BNE @no_load

        ; set real level from next_level
        LDA next_level
        STA level

        ; load the new level (this already handles vram_busy, $2000/$2001, etc.)
        JSR LoadLevel

        ; now switch to flicker-on phase (3)
        LDA #$03
        STA transition_phase

        LDA #16         ; flicker-on frames
        STA transition_frames

@no_load:

    ; ===== UPDATE section =====
    ; START STATE
    LDA state
    CMP #$00
    BNE :+
        JSR StartScreenStateUpdate
    :

    ; if we are in a transition, you might want to skip gameplay updates
    LDA transition_phase
    BEQ @do_game_update
    JMP @after_game_update

@do_game_update:
    ; GAME STATE
    LDA state
    CMP #$01
    BNE :+
        JSR UpdateGameLoop
    :

@after_game_update:

    ; GAME OVER STATE
    LDA state
    CMP #$02
    BNE :+
        JSR ClearOAM
    :

    JMP INFLOOP






UpdateGameLoop:
    JSR TimerUpdate
    JSR PlayerHitTimer
    JSR GetRandom
    JSR ReadController1
    JSR HandleDpad
    JSR EnemyUpdate
    JSR GetNewEnemyRandomWalkTimer
    ; JSR UpdateThunder
    JSR UpdateBulet
    JSR DoorUpdate
    JSR UpdatePlayer
    JSR UpdateMapLoader
    JSR MimicUpdate
@return:
    RTS



DrawGameLoop:

    JSR TimerDraw
    JSR DrawDoor
    JSR Undraw_door
    JSR ANITMATION
    JSR DrawEnemies
    JSR DRAWPLAYER
    JSR DrawMoveableBlock
    JSR DrawBullet   
    JSR DrawMimic

    LDA is_door_unlocked
    STA $0160
    LDA can_undraw_door
    STA $0161
    LDA door_draw_pending
    STA $0162
RTS



NMI:


    INC rand8
    PHA
    TXA
    PHA
    TYA
    PHA
    
   

    LDA #1
    STA vblank_flag

    ; ===== OAM DMA =====
    LDA vram_busy
    BNE skip_dma
        LDA #$02
        STA $4014
skip_dma:

    ; ===== HANDLE TRANSITION FLICKER =====
    LDA transition_phase
    BEQ @no_transition   ; 0 = normal rendering

    CMP #$01
    BEQ @flicker_off
    CMP #$02
    BEQ @transition_dark
    CMP #$03
    BEQ @flicker_on
    JMP @no_transition

@flicker_off:
    ; phase 1: flicker, end in black + phase 2
    LDA frame_counter
    AND #%00000011
    BEQ @lights_off1
    LDA #%00011110
    JMP @write_2001_1
@lights_off1:
    LDA #$00
@write_2001_1:
    STA $2001

    DEC transition_frames
    BNE @end_transition_draw

    LDA #$00
    STA $2001       ; full black
    LDA #$02
    STA transition_phase
    JMP @end_transition_draw

@transition_dark:
    ; phase 2: keep black while main loop loads room
    LDA #$00
    STA $2001
    JMP @end_transition_draw

@flicker_on:
    ; phase 3: flicker new room, end in normal
    LDA frame_counter
    AND #%00000011
    BEQ @lights_off3
    LDA #%00011110
    JMP @write_2001_3
@lights_off3:
    LDA #$00
@write_2001_3:
    STA $2001

    DEC transition_frames
    BNE @end_transition_draw

    LDA #%00011110
    STA $2001       ; fully on
    LDA #$00
    STA transition_phase
    JMP @end_transition_draw

@end_transition_draw:
    ; while in transition, skip normal DrawGameLoop
    JMP @after_draw

@no_transition:
    ; ===== NORMAL DRAW section =====
    ; START STATE
    LDA state
    CMP #$00
    BNE :+
        JSR StartScreenStateUpdatDraw
    :

    ; GAME STATE
    LDA state
    CMP #$01
    BNE :+
        JSR DrawGameLoop
    :

    ; GAME OVER
    LDA state
    CMP #$02
    BNE :+
        JSR ClearOAM
    :


@after_draw:
    JSR famistudio_update
    PLA
    TAY
    PLA
    TAX
    PLA
    RTI



GetRandom:
    LDA rand8
    LSR A          ; shift right, bit0 -> carry
    BCC no_xor
    EOR #$B8       ; tap polynomial

no_xor:
    STA rand8
    RTS






LoadState1:

    lda #0                 ; play song 0
    jsr famistudio_music_play


    ; JSR LoadRandomRoom
    ; JSR LOADSPRITES
    JSR LoadLevel
    ; JSR LoadEnemies
    ; JSR LoadBlocks
    ; JSR UpdateHealth
    JSR LoadPlayer
    JSR LoadMimic

    RTS



; Wait exactly one vblank/frame
WaitOneFrame:
WaitLoop:
    LDA vblank_flag
    BEQ WaitLoop
    LDA #0
    STA vblank_flag
    RTS



; ===========================
; LightsFlickerOff
;  - Flickers the lights a bit
;  - Ends with screen fully OFF ($2001 = 0)
; ===========================

LightsFlickerOff:
    LDX #16          ; number of flicker frames (tweak this)
@flicker_loop_off:
    JSR WaitOneFrame

    ; use frame_counter low bits to decide on/off
    LDA frame_counter
    AND #%00000011   ; look at last 2 bits
    BEQ @lights_off  ; ~25% of time: off

    ; lights ON this frame
    LDA #%00011110   ; BG+sprites on, your normal setting
    JMP @write_2001

@lights_off:
    LDA #$00         ; everything off

@write_2001:
    STA $2001

    DEX
    BNE @flicker_loop_off

    ; end in total darkness
    LDA #$00
    STA $2001
    RTS



; ===========================
; LightsFlickerOn
;  - Starts from black
;  - Flickers a bit
;  - Ends with screen fully ON ($2001 = %00011110)
; ===========================

LightsFlickerOn:
    LDX #16          ; number of flicker frames (tweak)

@flicker_loop_on:
    JSR WaitOneFrame

    LDA frame_counter
    AND #%00000011
    BEQ @lights_off2   ; sometimes off

    ; lights ON this frame
    LDA #%00011110
    JMP @write_2001_2

@lights_off2:
    LDA #$00

@write_2001_2:
    STA $2001

    DEX
    BNE @flicker_loop_on

    ; end with lights ON
    LDA #%00011110
    STA $2001
    RTS
