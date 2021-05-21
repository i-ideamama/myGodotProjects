extends KinematicBody2D


onready var STAPLER = preload("res://Scenes/Stapler.tscn")
onready var player = get_parent().get_node("Player")
var npcSPD = Vector2(250,0)
var stapler
var gravity = 2500
var velocity = npcSPD
var throw_dist
var throw_on_player = false


func _physics_process(delta):
	if throw_on_player: # If we are attacking, don't move
		return
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)


	if velocity.x == 0:
		npcSPD *= -1
		velocity = npcSPD
		
func throw():
	throw_dist = player.position.x - position.x
	stapler = STAPLER.instance()
	add_child(stapler)
	stapler.position = Vector2(0, -18)
	
	stapler.throw(throw_dist)

func _on_Area2D_body_entered(body):
	if player.happiness < 50 and body == player:
		if player.hasCharger == false or player.hasChair == false:
			throw_on_player = true
			throw()


func _on_Area2D_body_exited(_body):
	throw_on_player = false


func _on_Timer_timeout():
	if throw_on_player:
		throw()
