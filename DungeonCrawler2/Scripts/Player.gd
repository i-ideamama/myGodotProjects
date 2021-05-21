extends KinematicBody

var speed = 7
var acceleration = 20
var gravity = 9.8
var jump = 5
var mouse_sensitivity = 0.005
var direction = Vector3()
var velocity = Vector3()
var fall = Vector3()

onready var head  = $Head


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _input(event):
	if event is InputEventMouseMotion:
		# applies horizontal mouse movement to horizontal camera movement
		rotate_y(-event.relative.x * mouse_sensitivity)
		# applies horizontal mouse movement to horizontal camera movement
		# rotation only the head keeps horizontal and vertical rotation separate
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))


func _process(delta):
	direction = Vector3.ZERO
	

#	if not is_on_floor():
#		fall.y -= gravity * delta
	if Input.is_action_just_pressed("jump"):
		fall.y = jump
		
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	#transform.basis sets the direction in which we "want" to move
	if Input.is_action_pressed("move_forwards"):
		direction -= transform.basis.z 
	elif Input.is_action_pressed("move_backwards"):
		direction += transform.basis.z
	if Input.is_action_pressed("move_right"):
		direction += transform.basis.x
	if Input.is_action_pressed("move_left"):
		direction += transform.basis.x
	
	direction = direction.normalized()
	#from velocity to direction*speed by acceleration*delta
	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta)
	velocity = move_and_slide(velocity, Vector3.UP)
	velocity = move_and_slide(fall, Vector3.UP)
