ANIM_SPEED = 10
NUM_FRAMES = 4

WIDTH = 16
HEIGHT = 16

FACINGUP = $20
FACINGDOWN = $0
FACINGLEFT = $60
FACINGRIGHT = $40

PLAYER_SPEED = 5

MOVETIMESPEED = 50
BLOCK_STEP = $f0
HitTimer = 30

ABTN      = %00000001   ; $01
BBTN      = %00000010   ; $02
SELECTBTN = %00000100   ; $04
STARTBTN  = %00001000   ; $08
UPBTN     = %00010000   ; $10
DOWNBTN   = %00100000   ; $20
LEFTBTN   = %01000000   ; $40
RIGHTBTN  = %10000000   ; $80

CHASERSETSPEED = 2

BLOCK_TILE_TL = $82      ; pick your actual tile ids
BLOCK_TILE_TR = $83
BLOCK_TILE_BL = $92
BLOCK_TILE_BR = $93
BLOCK_ATTR    = $00      ; palette/priority/flip

ENEMY_TILE_TL = $08      ; pick your actual tile ids
ENEMY_TILE_TR = $09
ENEMY_TILE_BL = $18
ENEMY_TILE_BR = $19
ENEMY_ATTR    = $00      ; palette/priority/flip

BLOCK_OAM_START = 12  
ENEMY_OAM_START = 24 

BULLET_OAM = $02a0
BULLET_TILE = $84
BULLET_SPEED = 2

MAX_TIMER = 255
TIMER_FPS = 60
;number tiles
num_0_tile = $d9
num_1_tile = $da
num_2_tile = $db
num_3_tile = $dc
num_4_tile = $dd
num_5_tile = $de
num_6_tile = $df
num_7_tile = $e0
num_8_tile = $e1
num_9_tile = $e2

TIMER_DIGIT_Y = $03
TIMER_DIGIT_X1 = $18
TIMER_DIGIT_X2 = $19
TIMER_DIGIT_X3 = $1A     

DOOR_POS_X = $0c
DOOR_POS_Y = $06