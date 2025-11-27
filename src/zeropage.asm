; ===== ZEROPAGE: tiny & hot stuff only =====
.segment "ZEROPAGE"
vblank_flag:        .res 1
controller1:        .res 1
controller1_prev:   .res 1
rand8:              .res 1

tmp:                .res 1   ; scratch
tile_x:             .res 1
tile_y:             .res 1
tmp_tile:.res 1
cur_tile: .res 1
moveable_block_x: .res 3
moveable_block_y: .res 3
moveable_block_count: .res 1

target_idx: .res 1
tx:         .res 1   

is_player_checking: .res 1
is_player_hit: .res 1
player_hit_timer: .res 1
player_y_pos: .res 1
frame_counter: .res 1

; tmp_push_block_x: .res 1
; tmp_push_block_y: .res 1
is_moveable_block_moved: .res 3

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



bullet_x: .res 1
bullet_y: .res 1
bullet_w: .res 1
bullet_h: .res 1
bullet_direction: .res 1
is_bullet_active: .res 1

timer_counter: .res 1
timer_tick_counter: .res 1

gameover: .res 1

player_x: .res 1
player_y: .res 1
player_tile_x: .res 1
player_tile_y: .res 1
player_tile: .res 1
player_direction: .res 1
player_health: .res 1

tmp_frame_off: .res 1


enemy_x: .res 3
enemy_y: .res 3
enemy_direction: .res 3
enemy_random_walk_timer: .res 3
is_enemy_active: .res 3
enemy_count: .res 1
enemy_kill_count: .res 1

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


oam_ptr_lo: .res 1
oam_ptr_hi: .res 1
tmpx:       .res 1
tmpx8:      .res 1
tmpy:       .res 1
tmpy8:      .res 1

enemy_loop_idx: .res 1

timer_s: .res 1
timer_ts: .res 1
timer_m: .res 1
level: .res 1


bgPtrLo:   .res 1
bgPtrHi:   .res 1
collPtrLo: .res 1
collPtrHi: .res 1
tempPtrLo: .res 1
tempPtrHi: .res 1

can_move_block: .res 1
is_block_moved_for_unlock: .res 1
temp_col: .res 1
current_tile_index: .res 1


mimic_direction: .res 1
mimic_x: .res 1
mimic_y: .res 1
player_x_prev: .res 1
player_y_prev: .res 1
tmp_delta: .res 1
mimic_tile_x: .res 1
mimic_tile_y: .res 1

block_move_pending: .res 1
block_to_index: .res 1
block_from_index: .res 1
can_undraw_door: .res 1
meta_row: .res 1
meta_col: .res 1
door_draw_pending: .res 1

can_draw_timer: .res 1



movable_block_floor_tile_x: .res 1
movable_block_floor_tile_y: .res 1
movable_block_new_tile_x: .res 1
movable_block_new_tile_y: .res 1
block_move_phase: .res 1
movable_block_index: .res 1
can_draw_health: .res 1
health_tmp: .res 1

.segment "BSS"

COLLISIONTABLE: .res 240




; bgPtr       = $10        ; 2 bytes: low + high
; bgPtrLo     = bgPtr
; bgPtrHi     = bgPtr+1

; collPtr     = $12
; collPtrLo   = collPtr
; collPtrHi   = collPtr+1

; tempPtrLo = $14
; tempPtrHi = $15

hundreds: .res 1
tens:     .res 1
ones:     .res 1

secret_tile: .res 1
is_door_unlocked: .res 1