extends Area2D
var phoneTimeout = 20
onready var clock = $"Clock Timer"
onready var clockUI = $"Clock Timer/Node2D"
var isActive = false

func activate():
	isActive = true
	clock.visible = true
	clockUI.startTimer(phoneTimeout)


func _ready():
	#activatePhone()
	pass
	
func deactivate():
	isActive = true
	clock.visible = false
	#clockUI.startTimer(phoneTimeout)
