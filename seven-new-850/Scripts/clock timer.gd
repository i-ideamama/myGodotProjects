extends Timer


onready var myLine = get_parent().get_node("Arc")
var seconds = 0
var timePassed = 0
func startTimer(sec):
	
	seconds = sec
	timePassed = 0
	start()
	
func _ready():
	startTimer(3)


		
	


func _on_Node2D_timeout():
	timePassed +=  wait_time
	myLine._draw_sector(0, floor(timePassed * 360 / seconds))
	#timePassed : seconds :: x : 360
	if timePassed > seconds:
		stop() # Replace with function body.
