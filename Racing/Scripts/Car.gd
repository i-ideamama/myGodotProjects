extends RigidBody2D


export var SPEED = 40

func _physics_process(_delta):
	if Input.is_action_pressed("ui_right"):
		$FrontWheel.angular_velocity = SPEED
		$RearWheel.angular_velocity = SPEED

	if Input.is_action_pressed("ui_left"):
		$FrontWheel.angular_velocity = -SPEED
		$RearWheel.angular_velocity = -SPEED

