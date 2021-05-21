extends Control



func _on_new_game_button_up():
	get_tree().change_scene("res://Grid.tscn")


func _on_quit_button_up():
	get_tree().quit()
