extends TileMap

enum POS_TYPE {EMPTY, OCCUPIED}
var grid = []
var random_block_spawn_pos = [
	Vector2(0,0),Vector2(0,1),Vector2(0,1),Vector2(0,3),Vector2(0,4),Vector2(0,5),Vector2(0,6),Vector2(0,7),Vector2(0,8),Vector2(0,9),Vector2(0,10),
	Vector2(10,0),Vector2(10,1),Vector2(10,1),Vector2(10,3),Vector2(10,4),Vector2(10,5),Vector2(10,6),Vector2(10,7),Vector2(10,8),Vector2(10,9),Vector2(10,10),
	Vector2(1,0),Vector2(2,0),Vector2(3,0),Vector2(4,0),Vector2(5,0),Vector2(6,0),Vector2(7,0),Vector2(8,0),Vector2(9,0),
	Vector2(1,10),Vector2(2,10),Vector2(3,10),Vector2(4,10),Vector2(5,10),Vector2(6,10),Vector2(7,10),Vector2(8,10),Vector2(9,10)
	]
var grid_size = Vector2(11,11)
var kolam_size = 3
var kolam
var kolam_center_frame = 4
var direction = Vector2.ZERO
var block_list = []
var available_frames = []
var game_over = false
var win = false

onready var KOLAM = preload("res://Scenes/Kolam.tscn")


func _ready():
	for frame in range(0,kolam_size*kolam_size):
		if not frame == kolam_center_frame:
			available_frames.append(frame)

	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
		
	kolam = KOLAM.instance()
	add_child(kolam)
	kolam.frame = kolam_center_frame
	kolam.position = map_to_world(Vector2(5,5))
	grid[5][5] = POS_TYPE.OCCUPIED
	block_list.append(kolam)
	new_block()


func _physics_process(_delta):
	if not game_over:
		get_input()
		move_current_block()
		if Input.is_action_just_pressed("set_block"):
			new_block()
	else:
		check_win()

func get_input():
	direction = Vector2.ZERO
	if Input.is_action_just_pressed("move_right"):
		direction.x += 1
	if Input.is_action_just_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_just_pressed("move_up"):
		direction.y -= 1
	if Input.is_action_just_pressed("move_down"):
		direction.y += 1


func move_current_block():
	var grid_pos = world_to_map(block_list[-1].position)
	var new_grid_pos = grid_pos + direction
	var target_pos
	
	if (new_grid_pos.x < 11 and new_grid_pos.x >= 0) && (new_grid_pos.y < 11 and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.OCCUPIED:
			target_pos = map_to_world(new_grid_pos)
		else: target_pos = map_to_world(grid_pos)
	else: target_pos = map_to_world(grid_pos)
	block_list[-1].position = target_pos
	

func new_block():
	var old_block_grid_pos = world_to_map(block_list[-1].position)
	grid[old_block_grid_pos.x][old_block_grid_pos.y] = POS_TYPE.OCCUPIED
	
	if len(available_frames) > 0:
		randomize()
		random_block_spawn_pos.shuffle()
		available_frames.shuffle()
		
		kolam = KOLAM.instance()
		add_child(kolam)
		block_list.append(kolam)
		kolam.frame = available_frames[0]
		available_frames.remove(0)
		kolam.position = map_to_world(random_block_spawn_pos[0])
	else:
		game_over = true


func check_win():
	var w = true
	
	for b in block_list:
		if not world_to_map(b.position) == Vector2(5,5) and b.frame == 4:
			w = false
		if not world_to_map(b.position) == Vector2(4,4) and b.frame == 0:
			w = false
		if not world_to_map(b.position) == Vector2(5,4) and b.frame == 1:
			w = false
		if not world_to_map(b.position) == Vector2(6,4) and b.frame == 2:
			w = false
		if not world_to_map(b.position) == Vector2(4,5) and b.frame == 3:
			w = false
		if not world_to_map(b.position) == Vector2(6,5) and b.frame == 5:
			w = false
		if not world_to_map(b.position) == Vector2(4,6) and b.frame == 6:
			w = false
		if not world_to_map(b.position) == Vector2(5,6) and b.frame == 7:
			w = false
		if not world_to_map(b.position) == Vector2(6,6) and b.frame == 8:
			w = false
	if w: print("win!")











