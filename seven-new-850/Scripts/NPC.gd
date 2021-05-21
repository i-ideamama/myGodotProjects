extends KinematicBody2D

onready var STAPLER = preload("res://Scenes/Stapler.tscn")
onready var player = get_parent().get_node("Player")
var npcSPD = Vector2(100,0)
var stapler
var gravity = 2500
var velocity = npcSPD
var throw_dist
var throw_on_player = false



func _ready():
	$Sprite.frame = 0	


func _physics_process(delta):
	if throw_on_player: # If we are attacking, don't move
		return
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity)


	if velocity.x == 0:
		npcSPD *= -1
		velocity = npcSPD
		if not $Sprite.frame == 1:$Sprite.frame = 1
		else: $Sprite.frame = 0
		
func throw():
	throw_dist = player.position.x - position.x
	stapler = STAPLER.instance()
	add_child(stapler)
	stapler.position = Vector2(0, -18)
	
	stapler.throw(throw_dist)

func _on_Area2D_body_entered(body):
	if player.happiness < 30 and body == player:
		throw_on_player = true
		throw()


func _on_Area2D_body_exited(_body):
	throw_on_player = false


func _on_Timer_timeout():
	if throw_on_player:
		throw()
