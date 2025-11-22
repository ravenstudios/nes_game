.include "levels/level_1.asm"
.include "levels/level_2.asm"
.include "levels/level_3.asm"
.include "levels/level_4.asm"
.include "levels/level_5.asm"
.macro LEVEL_ENTRY bgLabel, collLabel
    .byte <bgLabel, >bgLabel, <collLabel, >collLabel
.endmacro



LevelTable:
    LEVEL_ENTRY Level_1_Data, Level_1_CollisionData   ; level = 0
    LEVEL_ENTRY Level_2_Data, Level_2_CollisionData   ; level = 1
    LEVEL_ENTRY Level_3_Data, Level_3_CollisionData   ; level = 2
    LEVEL_ENTRY Level_4_Data, Level_4_CollisionData   ; level = 2
    LEVEL_ENTRY Level_5_Data, Level_5_CollisionData   ; level = 2



