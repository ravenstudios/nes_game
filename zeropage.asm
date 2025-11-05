; XVEL: .RES 1
; XPOS: .RES 1
; YPOS: .RES 1

PLAYER_X: .res 1
PLAYER_Y: .res 1
PLAYER_W: .res 1
PLAYER_H: .res 1
PLAYERDIRECTION: .res 1

ENEMY_X: .res 1
ENEMY_Y: .res 1
ENEMY_W: .res 1
ENEMY_H: .res 1
ENEMYDIRECTION: .res 1
EnemyRandomWalkTimer: .res 1

collision_check_x: .res 1
collision_check_y: .res 1


move_timer: .res 1

anim_timer: .res 1
anim_frame: .res 1
vblank_flag: .res 1

controller1: .res 1
controller1_prev: .res 1   ; optional (for detecting presses)



index_low_byte: .res 1
index_high_byte: .res 1
index_pointer_low: .res 1
index_pointer_high: .res 1

tile_x: .res 1
tile_y: .res 1

rand8:  .res 1 