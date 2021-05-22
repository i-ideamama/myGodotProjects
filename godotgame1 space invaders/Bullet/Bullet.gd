extends KinematicBody2D

var speed = 500

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_physics_process(true)


func _physics_process(delta):
	var collided_object = move_and_collide(Vector2(0, -speed*delta))
	if collided_object:
		# deleting the object from the tree that the bullet collided with then delete the bullet
		collided_object.get_collider().queue_free()
		queue_free()