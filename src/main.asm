; .include "ppu.asm"
; .include "audio.asm"

.include "constants.inc"
.segment "HEADER"
	.include "header.asm"


.segment "ZEROPAGE"
.include "zeropage.asm"



.segment "STARTUP"

.include "reset.asm"
IRQ:
    RTI


    

	
.segment "CODE"
.include "collision.asm"
.include "gamelogic.asm"


.segment "VECTORS"
	.word NMI
	.word RESET
    .word IRQ
	

.segment "CHARS"
	.incbin "romx.chr"

