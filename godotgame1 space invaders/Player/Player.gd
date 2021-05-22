extends KinematicBody2D

var bullet = preload("res://Bullet/Bullet.tscn")
export var speed = 200

# Called when the node enters the scene tree for the first time.
func _ready():
	# enabling processes
	set_process(true)
	set_physics_process(true)
	
func _process(delta):
	if Input.is_action_just_pressed('fire'):
		# spawn a bullet
		var bulletInstance = bullet.instance()
		bulletInstance.position = Vector2(position.x, position.y - 20)
		get_tree().get_root().add_child(bulletInstance)

# physcs process function
func _physics_process(delta):
	if Input.is_action_pressed('ui_left'):
		 # speed per second - multiply by delta
		move_and_collide(Vector2(-speed*delta, 0))
	elif Input.is_action_pressed('ui_right'):
		move_and_collide(Vector2(speed*delta, 0))
		
	
