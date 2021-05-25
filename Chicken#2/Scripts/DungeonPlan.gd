extends Node2D

var borders = Rect2(1,1,38,21)
onready var tileMap = $TileMap


func _ready():
	# creates a new random seed
	randomize()
	generate_level()
	print(tileMap.get_used_cells())


func generate_level():
	var walker = Walker.new(Vector2(19,11),borders)
	var map = walker.walk(100)
	walker.queue_free()
	
	for location in map:
		tileMap.set_cell(location.x, location.y , 0)
	tileMap.update_bitmask_region(borders.position, borders.end)


func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
