extends Sprite

var direction = Vector2()


func update_direction():
	direction.x = 0
	if Input.is_action_just_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		direction.x -= 1
