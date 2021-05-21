extends TileMap


onready var player = $"/root/player"
# variables
enum POS_TYPE {EMPTY, PLAYER, OCCUPIED}
var grid = []
var grid_size = Vector2(10,10)


func _ready():
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = POS_TYPE.EMPTY
	grid[0][0] = POS_TYPE.OCCUPIED
	
	player.position = Vector2(320,320)
	print(grid, player.position)


func _physics_process(delta):
	
	if Input.is_action_just_pressed("un_occupy"):
		grid[0][0] = POS_TYPE.EMPTY
	
	player.update_direction()
	move_player()


func move_player():
	var grid_pos = world_to_map(player.position)
	var prev_grid_pos = grid_pos
	var new_grid_pos = grid_pos + player.direction
	var target_pos
	
	grid[grid_pos.x][grid_pos.y] = POS_TYPE.PLAYER
	
	if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 9 and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.OCCUPIED:
			target_pos = map_to_world(new_grid_pos)
		else:
			target_pos = map_to_world(prev_grid_pos)
	else:
		target_pos = map_to_world(prev_grid_pos)
	player.position = target_pos
