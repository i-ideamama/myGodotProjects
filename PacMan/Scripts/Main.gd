extends TileMap


const PAC_MAN = preload("res://Scenes/PacMan.tscn")
const WALL = preload("res://Scenes/Wall.tscn")
const COIN = preload("res://Scenes/coin.tscn")
const GHOST = preload("res://Scenes/ghost.tscn")

enum POS_TYPE {EMPTY,COIN, WALL, GHOST}


var grid = []
var grid_size = Vector2(10, 10)
var direction = Vector2(0,0)
var wall_pos_list = [
	Vector2(64,64),Vector2(128,64), Vector2(192,64),Vector2(256,64),Vector2(320,64), Vector2(384,64),Vector2(448,64),Vector2(512,64),
	Vector2(64,192),Vector2(128,192), Vector2(192,192),Vector2(256,192),Vector2(320,192), Vector2(384,192),Vector2(448,192),Vector2(512,192),
	Vector2(64,320),Vector2(128,320), Vector2(192,320),Vector2(256,320),Vector2(320,320), Vector2(384,320),Vector2(448,320),Vector2(512,320),
	Vector2(64,448),Vector2(128,448), Vector2(192,448),Vector2(256,448),Vector2(320,448), Vector2(384,448),Vector2(448,448),Vector2(512,448)
	]


var pac_man
var wall
var coin
var ghost
var coin_list = []
var coin_count = 0
var ghost_list = []

onready var coin_counter = $coin_counter


func _ready():
	
	
	pac_man = PAC_MAN.instance()
	add_child(pac_man)
	pac_man.position = Vector2(0,0)
	
	build_walls()
	summon_ghosts()
	scatter_coins()


func _physics_process(_delta):
	get_direction()
	move_pac_man()


func build_walls():
	var w_grid_pos
	
	for w_pos in wall_pos_list:
		wall = WALL.instance()
		add_child(wall)
		wall.position = w_pos
		w_grid_pos = world_to_map(w_pos)
		grid[w_grid_pos.x][w_grid_pos.y] = POS_TYPE.WALL


func get_direction():
	if Input.is_action_just_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		direction.x -= 1
	elif Input.is_action_just_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_just_pressed("ui_down"):
		direction.y += 1


func move_pac_man():
	var grid_pos = world_to_map(pac_man.position)
	var new_grid_pos = grid_pos + direction
	var grid_target_pos = grid_pos
	
	if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 9 and new_grid_pos.y >= 0):
		if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.WALL:
			if grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.COIN:
				
				for c in coin_list:
					if world_to_map(c.position) == grid_pos:
						if c in get_children():
							c.get_index()
							remove_child(c)
							coin_count += 1
							coin_counter.text = str(coin_count)
							
			grid_target_pos = new_grid_pos
	
	
	pac_man.position = map_to_world(grid_target_pos)

	direction = Vector2.ZERO


func summon_ghosts():
	var ghost_grid_pos
	
	ghost = GHOST.instance()
	add_child(ghost)
	ghost.position = Vector2(256,576)
	ghost_grid_pos = world_to_map(ghost.position)
	grid[ghost_grid_pos.x][ghost_grid_pos.y] = POS_TYPE.GHOST
	ghost_list.append(ghost)
	
	ghost = GHOST.instance()
	add_child(ghost)
	ghost.position = Vector2(320,576)
	ghost_grid_pos = world_to_map(ghost.position)
	grid[ghost_grid_pos.x][ghost_grid_pos.y] = POS_TYPE.GHOST
	ghost_list.append(ghost)


func scatter_coins():
	for x in range(len(grid)):
		for y in range(len(grid[x])):
			if grid[x][y] == POS_TYPE.EMPTY and Vector2(x,y) != Vector2(0,0):
				coin = COIN.instance()
				add_child(coin)
				coin_list.append(coin)
				coin.position = map_to_world(Vector2(x,y))
				grid[x][y] = POS_TYPE.COIN


func move_ghost():
	for g in ghost_list:
		var grid_pos = world_to_map(g.position)
		var new_grid_pos = grid_pos + g.direction
		var grid_target_pos = grid_pos
		
		if (new_grid_pos.x <= 9 and new_grid_pos.x >= 0) && (new_grid_pos.y <= 9 and new_grid_pos.y >= 0):
			if not grid[new_grid_pos.x][new_grid_pos.y] ==  POS_TYPE.WALL:
				grid_target_pos = new_grid_pos
			else:
				g.direction = g.r_dir_list[randi()%g.r_dir_list.size()]
		else:
			g.direction = g.r_dir_list[randi()%g.r_dir_list.size()]
		
		g.position = map_to_world(grid_target_pos)


func _on_ghost_move_timer_timeout():
	move_ghost()
