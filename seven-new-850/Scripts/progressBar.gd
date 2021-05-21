extends ProgressBar

onready var timer = get_child(0)
var needed_val = 0
var step_size = step
var repeat = 10
var change_needed = false

func Update_Bar(val):
	needed_val = val
	#value = val
	change_needed = true

# Called when the node enters the scene tree for the first time.


func timer_timeout():
	for _i in range(repeat):
		if change_needed:
			if abs(value - needed_val) < step_size:
				#print(needed_val,value)
				value = needed_val
				change_needed = false
			else:
				if value < needed_val:
					value += step_size
				else:
					value -= step_size
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass"res://Scripts/progressBar.gd"


func _on_Timer_timeout():
	timer_timeout()


