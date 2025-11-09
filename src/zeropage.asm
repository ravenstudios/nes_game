; ===== ZEROPAGE: tiny & hot stuff only =====
.segment "ZEROPAGE"
vblank_flag:        .res 1
controller1:        .res 1
controller1_prev:   .res 1
rand8:              .res 1

tmp:                .res 1   ; scratch
tile_x:             .res 1
tile_y:             .res 1


moveable_block_x: .res 1
moveable_block_y: .res 1

is_player_hit: .res 1
player_hit_timer: .res 1
player_y_pos: .res 1
frame_counter: .res 1



is_moveable_block_moved: .res 1

collide_check_1x: .res 1
collide_check_1y: .res 1


collide_check_2x: .res 1
collide_check_2y: .res 1


t1_minx: .res 1
t1_maxx: .res 1
t1_miny: .res 1
t1_maxy: .res 1
t2_minx: .res 1
t2_maxx: .res 1
t2_miny: .res 1
t2_maxy: .res 1



.segment "BSS"
PLAYER_X: .res 1
PLAYER_Y: .res 1

PLAYERDIRECTION: .res 1

ENEMY_X: .res 1
ENEMY_Y: .res 1

ENEMYDIRECTION: .res 1
EnemyRandomWalkTimer: .res 1

CHASERENEMY_X: .res 1
CHASERENEMY_Y: .res 1

CHASERENEMYDIRECTION: .res 1
CHASERSPEEDCOUNTER: .res 1
CHASERDIRECTION: .res 1


collision_check_x: .res 1
collision_check_y: .res 1

collision_check_dir: .res 1


move_timer:  .res 1
anim_timer:  .res 1
anim_frame:  .res 1



rand_col: .res 1
rand_row: .res 1

loop_counter: .res 1


tmp0: .res 1
tmp1: .res 1
loadedTile: .res 1

random_seed: .res 1
button_pressed: .res 1
start_screen: .res 1

state: .res 1
vram_busy: .res 1

COLLISIONTABLE: .res 240





pushable_contact: .res 1