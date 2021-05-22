extends KinematicBody2D

var speed = 200


func _ready():
	set_physics_process(true)
	

func _physics_process(delta):
	move_and_collide(Vector2(speed*delta, 0))

