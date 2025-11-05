XVEL: .RES 1
XPOS: .RES 1
YPOS: .RES 1

PLAYER_X: .res 1
PLAYER_Y: .res 1
PLAYER_W: .res 1
PLAYER_H: .res 1

ENEMY_X: .res 1
ENEMY_Y: .res 1
ENEMY_W: .res 1
ENEMY_H: .res 1

move_timer: .res 1

anim_timer: .res 1
anim_frame: .res 1
vblank_flag: .res 1

controller1: .res 1
controller1_prev: .res 1   ; optional (for detecting presses)

direction: .res 1 
NEXT_X: .res 1
NEXT_Y: .res 1

COLLISIONTABLE: .res 1

index_low_byte = $90
index_high_byte = $91
index_pointer_low = $92
index_pointer_high = $93

tile_x = $0080
tile_y = $0081

player_coll_x: .res 1
player_coll_y: .res 1