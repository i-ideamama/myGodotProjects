extends TileMap

enum POS_TYPE {EMPTY, OCCUPIED}

var grid = []
var grid_size = Vector2(16,16)
var direction = Vector2.ZERO

const PLAYER = preload("res://Scenes/Player.tscn")
var player

func _ready():

	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
			
	player = PLAYER.instance()
	add_child(player)
	player.position = Vector2(0,0)


func _physics_process(_delta):
	get_dir()
	
	if direction != Vector2.ZERO:
		player.position = get_player_cartesian_pos()


func get_dir():
	direction = Vector2.ZERO
	if Input.is_action_just_pressed("move_right"):
		direction.x = 1
	elif Input.is_action_just_pressed("move_left"):
		direction.x  = -1
	elif Input.is_action_just_pressed("move_up"):
		direction.y = -1
	elif Input.is_action_just_pressed("move_down"):
		direction.y  = 1

func get_player_cartesian_pos():
	var grid_pos = world_to_map(player.position)
	var new_grid_pos = grid_pos+direction
	var target_pos
	
	if (new_grid_pos.x <= (grid_size.x-1) and new_grid_pos.x >= 0) && (new_grid_pos.y <= (grid_size.y-1) and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.OCCUPIED:
			target_pos = map_to_world(new_grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

		else:
			target_pos = map_to_world(grid_pos)
			grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY

	else:
		target_pos = map_to_world(grid_pos)
		grid[grid_pos.x][grid_pos.y] = POS_TYPE.EMPTY
	return target_pos
