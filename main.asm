; .include "ppu.asm"
; .include "audio.asm"


.segment "HEADER"
	.include "header.asm"


.segment "ZEROPAGE"
.include "zeropage.asm"


.segment "STARTUP"
.include "reset.asm"

.include "constants.inc"
    

	
.segment "CODE"
.include "gamelogic.asm"


.segment "VECTORS"
	.word NMI
	.word RESET
	

.segment "CHARS"
	.incbin "rom.chr"

