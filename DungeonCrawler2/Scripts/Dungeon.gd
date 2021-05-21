extends Spatial


var borders = Rect2(1,1,38,21)
var player_translation
var player = preload("res://Scenes/Player.tscn")
var WALL = preload("res://Scenes/Tile.tscn")
var wall
var level_gen = 0

func _ready():
	randomize()
	generate_level()
	
	player = player.instance()
	add_child(player)
	player.translation = player_translation
	print(player.translation)

func generate_level():
	var walker = Walker.new(Vector2(19,11),borders)
	var map = walker.walk(200)
	print(map[0])
	var dungeon_floor = walker.step_history
	walker.queue_free()
	
	for location in map:
		$GridMap.set_cell_item(location.x,0,location.y,0)
		if level_gen == 0:
			player_translation = Vector3(location.x,0,location.y)
			level_gen = 1
