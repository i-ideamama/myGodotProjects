extends TileMap

var steve
var grass_block
var dirt_block

var grid = []
var grid_size = Vector2(30, 20)
var gen_start_point = Vector2(0,9)
var block_pos_list = []
var rng = RandomNumberGenerator.new()
var block_y = 9
var steve_spawn_pos

enum BLOCK_TYPE {EMPTY, BLOCK}

const GRASS_BLOCK = preload("res://Scenes/Grass.tscn")
const STEVE = preload("res://Scenes/Steve.tscn")
const DIRT_BLOCK = preload("res://Scenes/Dirt.tscn")

func _ready():
	for x in grid_size.x:
		grid.append([])
		for y in grid_size.y:
			grid[x].append(y)
			grid[x][y] = BLOCK_TYPE.EMPTY
	
	steve = STEVE.instance()
	
	generate_world()
	create_terrain()
	
	add_child(steve)
	steve.position = steve_spawn_pos

func generate_world():
	var new_y
	var new_pos_generated = false

	for x in range(len(grid)):
		new_pos_generated = false

		while new_pos_generated == false:
			rng = RandomNumberGenerator.new()
			rng.randomize()
			new_y = rng.randi_range(0, 2)

			if new_y == 0:
				new_y = 0
			elif new_y == 1:
				new_y = 1
			elif new_y == 2:
				new_y = -1

			if new_y + block_y < 19 and new_y + block_y > 3:
				block_y += new_y
				new_pos_generated = true

		block_pos_list.append(Vector2(x,block_y))


func create_terrain():
	var grass_block_pos
	
	for pos in block_pos_list:
		
		
		grass_block = GRASS_BLOCK.instance()
		add_child(grass_block)
		
		grass_block_pos = map_to_world(pos)
		grass_block.position = grass_block_pos

		for p in range(grass_block_pos.y+32, 640, 32):
			dirt_block = DIRT_BLOCK.instance()
			add_child(dirt_block)
			dirt_block.position = Vector2(grass_block_pos.x, p)
		
		if pos == block_pos_list[0]:
			steve_spawn_pos = Vector2(grass_block_pos.x ,grass_block_pos.y - 48)

