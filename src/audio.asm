; ===== audio.asm =====
; simple thunder SFX using the noise channel

; ZP vars (we’ll add them to zeropage.asm in a sec)
;   thunder_active
;   thunder_timer

StartThunder:
    ; configure noise channel
    ; $400C: DDLC VVVV
    ; D = length counter halt, L = constant volume, V = volume
    LDA #%00101111        ; length halt=0, const volume=1, volume=15
    STA $400C

    ; $400E: ---- PPPP  (period index, lower = lower pitch)
    LDA #%00000001        ; low, rumbly noise
    STA $400E

    ; $400F: LLLL L--- (length counter, but we’re going to stop manually)
    LDA #$00
    STA $400F

    ; enable noise channel (bit 3) in $4015
    LDA #%00001000
    STA $4015

    ; how long the thunder lasts (frames)
    LDA #60               ; ~1 second at 60 FPS
    STA thunder_timer

    LDA #$01
    STA thunder_active
    RTS


UpdateThunder:
    LDA thunder_active
    BEQ @done

    DEC thunder_timer
    BNE @done

    ; time’s up – silence noise
    LDA #$00
    STA $4015        ; no channels enabled (fine for now)
    LDA #$00
    STA thunder_active

@done:
    RTS
