extends KinematicBody2D


var velocity = Vector2.ZERO
var gravity = Vector2(0, 5)
var y_down = 5
var isThrown = false
var error = 5
var time = 20

func _physics_process(delta):
	if isThrown:
		addForce(gravity,delta)
		var collidedwith = move_and_collide(velocity)
		if collidedwith:
			if collidedwith.get_collider().name == "Player":
				collidedwith.get_collider().getHit()
			print('throwable collided with ',collidedwith.get_collider())
			queue_free()
	pass

func throw(dist):
	isThrown = true
	velocity = Vector2((dist / time),((-0.5 * gravity.y) / y_down))
	

func addForce(F,delta): # Takes in a Vec2 and delta time
	velocity += F * delta
