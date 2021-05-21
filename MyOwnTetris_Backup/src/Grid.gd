extends TileMap

const BLOCK = preload("res://Block.tscn")

onready var BlockSlider = $'BlockSlider'
onready var Score_count = $'Score_count'
onready var Lines_count = $'Lines_count'

enum POS_TYPE {EMPTY, OCCUPIED}
enum PIECE_TYPE {O, T, S, Z, L, J, I}
enum ORIENTATION_TYPE {UP, DOWN, RIGHT, LEFT}

var grid = []
var grid_size = Vector2(10, 20)
var current_piece_type
var current_block_list = []
var main_block_grid_pos
var direction := Vector2.ZERO
var current_piece_orientation
var block_count
var run_num = 0
var rng = RandomNumberGenerator.new()
var rows_to_be_cleared = []
var rows_cleared_at_once = 0
var pause_new_piece = false

func _ready():
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
	
	rng.randomize()
	var random_number = rng.randi_range(0, 6)
	current_piece_type = get_random_piece(random_number)
	current_piece_orientation = ORIENTATION_TYPE.UP
	
	new_piece()
	BlockSlider.paused = true
	
	
func _physics_process(_delta):
	run_num = 1
	check_clear_row()

	if Input.is_action_just_pressed("rotate_clockwise"):
		rotate_piece()
	move_piece()
	get_piece_direction()

func new_piece():

	BlockSlider.paused = true
		
	var current_block_grid_pos
	if run_num == 1:
		for b in current_block_list:
			current_block_grid_pos = world_to_map(b.position)
			grid[current_block_grid_pos.x][current_block_grid_pos.y] = POS_TYPE.OCCUPIED
		
	rng.randomize()
	var random_number = rng.randi_range(0, 6)
	current_piece_type = get_random_piece(random_number)
	current_piece_orientation = ORIENTATION_TYPE.UP

	current_piece_orientation = ORIENTATION_TYPE.UP
	current_block_list = []
		
	for b in range(4):
			current_block_list.append(BLOCK.instance())
			add_child(current_block_list[b])
		
	if current_piece_type == PIECE_TYPE.O:
			current_block_list[0].position = map_to_world(Vector2(0,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(0.9,1,0)
			
	elif current_piece_type == PIECE_TYPE.T:
			current_block_list[0].position = map_to_world(Vector2(5,1))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(0.63,0,1)
			
	elif current_piece_type == PIECE_TYPE.S:
			current_block_list[0].position = map_to_world(Vector2(5,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(0,1,0)
		
	elif current_piece_type == PIECE_TYPE.Z:
			current_block_list[0].position = map_to_world(Vector2(5,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(1,0,0)
			
	elif current_piece_type == PIECE_TYPE.L:
			current_block_list[0].position = map_to_world(Vector2(5,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(0,0,1)
		
	elif current_piece_type == PIECE_TYPE.J:
			current_block_list[0].position = map_to_world(Vector2(5,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			for b in current_block_list:
				b.modulate = Color(1,0.5,0)
			
	elif current_piece_type == PIECE_TYPE.I:
			current_block_list[0].position = map_to_world(Vector2(5,0))
			main_block_grid_pos = world_to_map(current_block_list[0].position)
			current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-2,main_block_grid_pos.y))
			current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
			current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
			for b in current_block_list:
				b.modulate = Color(1,1,1)


func move_piece():
	var grid_pos = world_to_map(current_block_list[0].position)
	var new_grid_pos = grid_pos + direction
	var can_all_blocks_move_list = []
	var b_grid_pos
	
	for b in len(current_block_list):
		
		grid_pos = world_to_map(current_block_list[b].position)
		new_grid_pos = grid_pos + direction
		if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 19 and new_grid_pos.y >= 0):
			if grid[new_grid_pos.x][new_grid_pos.y] == POS_TYPE.OCCUPIED:
				can_all_blocks_move_list.append(false)
			elif grid[new_grid_pos.x][new_grid_pos.y] == POS_TYPE.EMPTY:
				can_all_blocks_move_list.append(true)
		else:
			can_all_blocks_move_list.append(false)
			

			
	if is_list_equal(can_all_blocks_move_list):
		for b in len(current_block_list):
			grid_pos = world_to_map(current_block_list[b].position)
			new_grid_pos = grid_pos + direction
			
			if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 19 and new_grid_pos.y >= 0):
				current_block_list[b].position = map_to_world(new_grid_pos)
#			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY
	
	for b in current_block_list:
		b_grid_pos = world_to_map(b.position)
	
		if (b_grid_pos.x <= 9 and b_grid_pos.x >= 0) && (b_grid_pos.y <= 19 and b_grid_pos.y >= 0):
			if b_grid_pos.y == 19:
				BlockSlider.paused = false
				break
			elif grid[b_grid_pos.x][b_grid_pos.y+1] == POS_TYPE.OCCUPIED:
				BlockSlider.paused = false
				break
	
	
	# Making the direction zero
	direction = Vector2.ZERO


func get_piece_direction():
	direction.x = 0
	if Input.is_action_just_pressed("ui_right"):
		direction.x = 1
	if Input.is_action_just_pressed("ui_left"):
		direction.x = -1


func rotate_piece():
	# rotates clockwise
	main_block_grid_pos = world_to_map(current_block_list[0].position)
	
	if current_piece_type == PIECE_TYPE.O:
		pass

	
	elif current_piece_type == PIECE_TYPE.T:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x, main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1, main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x, main_block_grid_pos.y+1))
				
					current_piece_orientation = ORIENTATION_TYPE.RIGHT
	
		elif current_piece_orientation == ORIENTATION_TYPE.RIGHT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1, main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x, main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1, main_block_grid_pos.y))
				
					current_piece_orientation = ORIENTATION_TYPE.DOWN
		
		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x, main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1, main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x, main_block_grid_pos.y+1))
				
					current_piece_orientation = ORIENTATION_TYPE.LEFT
				
		elif current_piece_orientation == ORIENTATION_TYPE.LEFT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
				
					current_piece_orientation = ORIENTATION_TYPE.UP


	elif current_piece_type == PIECE_TYPE.S:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x-1][main_block_grid_pos.y-1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.DOWN
			
		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.UP


	elif current_piece_type == PIECE_TYPE.Z:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x+1][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.DOWN

		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y-1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.UP

	
	elif current_piece_type == PIECE_TYPE.L:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y-1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					
					current_piece_orientation = ORIENTATION_TYPE.RIGHT
			
		elif current_piece_orientation == ORIENTATION_TYPE.RIGHT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x-1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[0].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.DOWN
			
		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY:
					current_block_list[0].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y))
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.LEFT
			
		elif current_piece_orientation == ORIENTATION_TYPE.LEFT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x-1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
				
					current_piece_orientation = ORIENTATION_TYPE.UP
	
	
	elif current_piece_type == PIECE_TYPE.J:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y+1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x-1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.RIGHT
			
		elif current_piece_orientation == ORIENTATION_TYPE.RIGHT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[0].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y+1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.DOWN
			
		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y-1] == POS_TYPE.EMPTY:
					current_block_list[0].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y))
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y-1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
			
					current_piece_orientation = ORIENTATION_TYPE.LEFT
			
		elif current_piece_orientation == ORIENTATION_TYPE.LEFT:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-1 >= 0) && (main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y+1] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y+1))
				
					current_piece_orientation = ORIENTATION_TYPE.UP
	
	
	elif current_piece_type == PIECE_TYPE.I:
		if current_piece_orientation == ORIENTATION_TYPE.UP:
			if (main_block_grid_pos.x <= 9 and main_block_grid_pos.x >= 0) && (main_block_grid_pos.y+2 <= 19 and main_block_grid_pos.y+1 <= 19 and main_block_grid_pos.y-1 >= 0):
				if grid[main_block_grid_pos.x][main_block_grid_pos.y-1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y+1] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x][main_block_grid_pos.y+2] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y-1))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+1))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x,main_block_grid_pos.y+2))
					
					current_piece_orientation = ORIENTATION_TYPE.DOWN
			
		elif current_piece_orientation == ORIENTATION_TYPE.DOWN:
			if (main_block_grid_pos.x+1 <= 9 and main_block_grid_pos.x-2 >= 0) && (main_block_grid_pos.y <= 19 and main_block_grid_pos.y >= 0):
				if grid[main_block_grid_pos.x-2][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x-1][main_block_grid_pos.y] == POS_TYPE.EMPTY and grid[main_block_grid_pos.x+1][main_block_grid_pos.y] == POS_TYPE.EMPTY:
					current_block_list[1].position = map_to_world(Vector2(main_block_grid_pos.x-2,main_block_grid_pos.y))
					current_block_list[2].position = map_to_world(Vector2(main_block_grid_pos.x-1,main_block_grid_pos.y))
					current_block_list[3].position = map_to_world(Vector2(main_block_grid_pos.x+1,main_block_grid_pos.y))
					
					current_piece_orientation = ORIENTATION_TYPE.UP


func is_list_equal(lst):
	var ele = lst[0]
	var chk = true
	for item in lst:
		if ele != item:
			chk = false
			break
	if chk == true:
		return true
	else:
		return false


func _on_BlockSpeed_timeout():
	direction.y = 1


func _on_BlockSlider_timeout():
	var b_grid_pos


	for b in current_block_list:
		b_grid_pos = world_to_map(b.position)
		
		if (b_grid_pos.x <= 9 and b_grid_pos.x >= 0) && (b_grid_pos.y <= 19 and b_grid_pos.y >= 0):
			if b_grid_pos.y == 19:
#				l.append(true)
				new_piece()
				break
				
			elif grid[b_grid_pos.x][b_grid_pos.y+1] == POS_TYPE.OCCUPIED:
#				l.append(true)
				new_piece()
				break


func get_random_piece(random_number):
	if random_number == 0:
		return PIECE_TYPE.O
	elif random_number == 1:
		return PIECE_TYPE.T
	elif random_number == 2:
		return PIECE_TYPE.S
	elif random_number == 3:
		return PIECE_TYPE.Z
	elif random_number == 4:
		return PIECE_TYPE.L
	elif random_number == 5:
		return PIECE_TYPE.J
	elif random_number == 6:
		return PIECE_TYPE.I


func check_clear_row():
	var y = 0
	
	while y <= 19:
		if grid[0][y] == POS_TYPE.OCCUPIED and grid[1][y] == POS_TYPE.OCCUPIED and grid[2][y] == POS_TYPE.OCCUPIED and grid[3][y] == POS_TYPE.OCCUPIED and grid[4][y] == POS_TYPE.OCCUPIED and grid[5][y] == POS_TYPE.OCCUPIED and grid[6][y] == POS_TYPE.OCCUPIED and grid[7][y] == POS_TYPE.OCCUPIED and grid[8][y] == POS_TYPE.OCCUPIED and grid[9][y] == POS_TYPE.OCCUPIED:
			rows_to_be_cleared.append(y)
		y += 1
	if len(rows_to_be_cleared) >= 1:
		clear_row()



func clear_row():
	var b_grid_pos
	var temp_b
	
	# Remove Sprites
	for y in rows_to_be_cleared:
		for b in range(get_child_count() - 7):
			temp_b = get_child(b)
			if temp_b is Sprite:
				b_grid_pos = world_to_map(temp_b.position)
				if b_grid_pos.y == y:
					remove_child(temp_b)

	
	for y in rows_to_be_cleared:
		for b in range(get_child_count() - 7):
			temp_b = get_child(b)
			if temp_b is Sprite:
				b_grid_pos = world_to_map(temp_b.position)
				if b_grid_pos.y < y:
					if grid[b_grid_pos.x][b_grid_pos.y+1] == POS_TYPE.EMPTY and b_grid_pos.y <= 19:
						grid[b_grid_pos.x][b_grid_pos.y] == POS_TYPE.EMPTY
						grid[b_grid_pos.x][b_grid_pos.y+1] == POS_TYPE.OCCUPIED
						temp_b.position.y += 32
	
	rows_to_be_cleared = []
