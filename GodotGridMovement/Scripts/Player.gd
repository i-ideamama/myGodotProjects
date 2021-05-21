extends Sprite

var direction = Vector2()

func update_direction():
	direction = Vector2.ZERO
	if Input.is_action_just_pressed("ui_up"):
		direction.y -= 1
	elif Input.is_action_just_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_just_pressed("ui_right"):
		direction.x += 1
	elif Input.is_action_just_pressed("ui_left"):
		direction.x -= 1
