extends Node
onready var animationPlayer = $Sprite/AnimationPlayer



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var inside_elevator = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func openDoor():
	print("Opening door")
	animationPlayer.play("elevator_open")
func closeDoor():
	print("Closing door")
	animationPlayer.play("elevator_close")

func _on_Door_Open_Area_body_entered(body):
	if body.name == "Player"  and not body.wants_to_move:
		openDoor()

func _on_Door_Open_Area_body_exited(body):
	if body.name == "Player" and not body.wants_to_move:
		closeDoor()

func _on_Elevator_Start_Area_body_entered(body):
	if body.name != "Player" or body.wants_to_move:return
	get_parent().get_parent().get_node("Player/UI/ElevatorController").showControls()

func _on_Elevator_Start_Area_body_exited(body):
	if body.name != "Player":return
	get_parent().get_parent().get_node("Player/UI/ElevatorController").hideControls()
	 # Replace with function body.
