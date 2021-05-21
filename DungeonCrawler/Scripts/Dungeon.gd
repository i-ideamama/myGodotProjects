extends Spatial


var borders = Rect2(1,1,38,21)
var floor_locations = []
var player = preload("res://Scenes/Player.tscn")
var WALL = preload("res://Scenes/Wall.tscn")
var wall
var block_positions
var level_gen = 0
var player_pos := Vector3()
var dungeon_floor

func _ready():
	randomize()
	generate_level()
	
	
	
	player = player.instance()
	add_child(player)
	block_positions = $GridMap.get_used_cells()
	player.translation.x = dungeon_floor[0].x
	player.translation.z = dungeon_floor[0].z
	player.translation.y = 10
	
	print(player.translation)
	print($GridMap.get_used_cells())


func generate_level():
	var walker = Walker.new(Vector2(19,11),borders)
	var map = walker.walk(200)
	var dungeon_floor = walker.step_history
	walker.queue_free()
	
#	for location in map:
#		$GridMap.set_cell_item(location.x,0,location.y,0)
#		if level_gen == 0:
#			player_pos = Vector3(location.x,3,location.y)
#			level_gen = 1
	
