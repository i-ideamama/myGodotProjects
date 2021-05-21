extends Control

onready var player = get_parent().get_parent()

func _ready():
	visible = false

func _on_1_pressed():
	player.elevateTo(1) # Replace with function body.


func _on_2_pressed():
	player.elevateTo(2) # Replace with function body.


func _on_3_pressed():
	player.elevateTo(3) # Replace with function body.


func _on_4_pressed():
	player.elevateTo(4) # Replace with function body.


func _on_5_pressed():
	player.elevateTo(5) # Replace with function body.


func _on_6_pressed():
	player.elevateTo(6) # Replace with function body.


func _on_7_pressed():
	player.elevateTo(7) # Replace with function body.
	
func hideControls():
	visible = false
	
func showControls():
	visible = true

	
