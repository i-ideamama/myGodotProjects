extends Node2D


onready var player = get_parent()
var dir = 0

func getDir():

	return dir
	dir = 0

func _on_move_left_pressed():
	dir = -1
	player.current_direction = player.DIRECTION.LEFT

func _on_move_right_pressed():
	dir = 1
	player.current_direction = player.DIRECTION.RIGHT

func _on_jump_pressed():
	player.jump()
	player.jump.play()

func _on_move_left_released():
	dir = 0

func _on_move_right_released():
	dir = 0
