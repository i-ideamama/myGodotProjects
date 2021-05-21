extends TileMap


const BLOCK = preload("res://Scenes/Block.tscn")
enum POS_TYPE {EMPTY, OCCUPIED}

var grid = []
var grid_size = Vector2(10,10)
var block_count = 0
var block_list = []
var current_block
var clear_row_list
var remove_block_list = []
var run = false
var game_over = false


onready var BlockSpeed = $'BlockSpeed'
onready var BlockSpeedIncreaser = $'BlockSpeedIncreaser'
onready var BlockCount = $'BlockCount'
onready var RowCount = $'RowCount'
onready var GameOver = $'GameOver'

func _ready():
	GameOver.visible = false
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
			
	current_block = BLOCK.instance()
	block_list.append(current_block)
	add_child(current_block)
	current_block.position = Vector2(256,0)
	
	grid[9][9] = POS_TYPE.EMPTY
	clear_row_list = ['(0, 9)','(1, 9)','(2, 9)','(3, 9)','(4, 9)','(5, 9)','(6, 9)','(7, 9)','(8, 9)','(9, 9)']

func _physics_process(_delta):
	if Input.is_action_just_pressed("ui") and run == false:
		run = true
	if run:
		if not current_block == null:
			current_block.update_direction()
			block_count = get_child_count() - 7
			BlockCount.text = str(block_count)
			move_block()
		
			if grid[0][9] == POS_TYPE.OCCUPIED and grid[1][9] == POS_TYPE.OCCUPIED and grid[2][9] == POS_TYPE.OCCUPIED and grid[3][9] == POS_TYPE.OCCUPIED and grid[4][9] == POS_TYPE.OCCUPIED and grid[5][9] == POS_TYPE.OCCUPIED and grid[6][9] == POS_TYPE.OCCUPIED and grid[7][9] == POS_TYPE.OCCUPIED and grid[8][9] == POS_TYPE.OCCUPIED and grid[9][9] == POS_TYPE.OCCUPIED:
				clear_row()
				if get_child_count() == 8:
					run = false
					game_over = true
	elif game_over and run == false:
		for b in range(len(block_list)):
			if block_list[b] in get_children():
				remove_child(block_list[b])
		BlockCount.text = '0'
		RowCount.text = '0'
		GameOver.visible = true
		
		

func move_block():
	var grid_pos = world_to_map(current_block.position)
	var prev_grid_pos = grid_pos
	var new_grid_pos = grid_pos + current_block.direction
	var target_pos
	var grid_target_pos


	if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 9 and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.OCCUPIED:
			target_pos = map_to_world(new_grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

		else:
			target_pos = map_to_world(prev_grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

	else:
		target_pos = map_to_world(prev_grid_pos)
		grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

	grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY
	grid_target_pos = world_to_map(target_pos)
	
	current_block.position = target_pos
	current_block.direction.y = 0
	
	if not block_count == 0:
		if grid_target_pos.y < 9:
			if not grid[grid_target_pos.x][grid_target_pos.y+1] == POS_TYPE.EMPTY:
				new_block()
		elif grid_target_pos.y == 9:
			new_block()


func new_block():
	var block = BLOCK.instance()
	var block_instance_grid_pos
	
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var rn = rng.randi_range(0, 9)
	
	add_child(block)
	block_list.append(block)
	if rn == 0:
		block.position = Vector2(0,0)
	elif rn == 1:
		block.position = Vector2(64,0)
	elif rn == 2:
		block.position = Vector2(128,0)
	elif rn == 3:
		block.position = Vector2(192,0)
	elif rn == 4:
		block.position = Vector2(256,0)
	elif rn == 5:
		block.position = Vector2(320,0)
	elif rn == 6:
		block.position = Vector2(384,0)
	elif rn == 7:
		block.position = Vector2(448,0)
	elif rn == 8:
		block.position = Vector2(512,0)
	elif rn == 9:
		block.position = Vector2(576,0)
	var world_to_map_block_pos = world_to_map(block.position)
	if grid[world_to_map_block_pos.x][world_to_map_block_pos.y] == POS_TYPE.OCCUPIED:
		run = false
		game_over = true
	
	block_instance_grid_pos = world_to_map(current_block.position)
	current_block = block_list[-1]

	grid[block_instance_grid_pos.x][block_instance_grid_pos.y] = POS_TYPE.OCCUPIED


func clear_row():
	for b in range(len(block_list)):
		if str(world_to_map(block_list[b].position)) in clear_row_list:
			if block_list[b] in get_children():
				remove_child(block_list[b])

	grid[0][9] = POS_TYPE.EMPTY
	grid[1][9] = POS_TYPE.EMPTY
	grid[2][9] = POS_TYPE.EMPTY
	grid[3][9] = POS_TYPE.EMPTY
	grid[4][9] = POS_TYPE.EMPTY
	grid[5][9] = POS_TYPE.EMPTY
	grid[6][9] = POS_TYPE.EMPTY
	grid[7][9] = POS_TYPE.EMPTY
	grid[8][9] = POS_TYPE.EMPTY
	grid[9][9] = POS_TYPE.EMPTY
	
	for b in range(len(block_list)):
		if block_list[b] in get_children():
			var temp_b_grid_pos = world_to_map(block_list[b].position)
			grid[temp_b_grid_pos.x][temp_b_grid_pos.y] = POS_TYPE.EMPTY
			block_list[b].position.y += 64
			temp_b_grid_pos = world_to_map(block_list[b].position)
			grid[temp_b_grid_pos.x][temp_b_grid_pos.y] = POS_TYPE.OCCUPIED
	var row_count_int = 0
	row_count_int += 1
	RowCount.text = str(row_count_int)
	

# BLOCK SPEED INCREASER
func _on_BlockSpeedIncreaser_timeout():
	if BlockSpeed.wait_time >= 0.4:
		BlockSpeed.wait_time -= 0.05
	else:
		 BlockSpeed.wait_time = 0.4

# BLOCK SPEED TIMER
func _on_Timer_timeout():
	if not current_block == null:
		current_block.direction.y = 1
	else:
		pass
