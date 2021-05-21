extends Node2D


onready var player = $Player
onready var uiDayChanger = $"Player/UI/Clock Timer/Node2D"
onready var dayOfWeek = $"Player/UI/DayOf Week"
onready var daysLeft = $"Player/UI/DaysLeft"

enum DAY {MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, SATURDAY, SUNDAY}

var current_day = DAY.MONDAY
var ppl_density
var days_completed = 0

func _ready():
	$LoopingTrack.play()
	uiDayChanger.startTimer(30)
	manage_stats()

func gameOver(win_or_lose):
	if win_or_lose == "Win":
		get_tree().change_scene("res://Scenes/GameOverWin.tscn")
	else:
		get_tree().change_scene("res://Scenes/GameOverLose.tscn")
		

func _on_Timer_timeout():

	if current_day == DAY.MONDAY:
		current_day = DAY.TUESDAY

	elif current_day == DAY.TUESDAY:
		current_day = DAY.WEDNESDAY
	
	elif current_day == DAY.WEDNESDAY:
		current_day = DAY.THURSDAY
		
	elif current_day == DAY.THURSDAY:
		current_day = DAY.FRIDAY
		
	elif current_day == DAY.FRIDAY:
		current_day = DAY.SATURDAY
		
	elif current_day == DAY.SATURDAY:
		current_day = DAY.SUNDAY
		
	elif current_day == DAY.SUNDAY:
		current_day = DAY.MONDAY
	uiDayChanger.startTimer(30)
	days_completed += 1
	if days_completed > 49:
		gameOver("Lose")
	manage_stats()
	


func manage_stats():
	if current_day == DAY.MONDAY:
		player.energy = min(70,player.health)
		player.happiness = min(60,player.health)
		ppl_density = 70
		dayOfWeek.text = "monday"
		
	elif current_day == DAY.TUESDAY:
		player.energy = min(60,player.health)
		player.happiness = min(40,player.health)
		ppl_density = 90
		dayOfWeek.text = "tuesday"
	
	elif current_day == DAY.WEDNESDAY:
		player.energy = min(45,player.health)
		player.happiness = min(55,player.health)
		ppl_density = 100
		dayOfWeek.text = "wednesday"
	
	elif current_day == DAY.THURSDAY:
		player.energy = min(50,player.health)
		player.happiness = min(60,player.health)
		ppl_density = 90
		dayOfWeek.text = "thursday"
	
	elif current_day == DAY.FRIDAY:
		player.energy = min(40,player.health)
		player.happiness = min(80,player.health)
		ppl_density = 80
		dayOfWeek.text = "friday"
	
	elif current_day == DAY.SATURDAY:
		player.energy = min(100,player.health)
		player.happiness = min(20,player.health)
		ppl_density = 80
		dayOfWeek.text = "saturday"
	
	elif current_day == DAY.SUNDAY:
		player.energy = min(90,player.health)
		player.happiness = min(5,player.health)
		ppl_density = 5
		dayOfWeek.text = "sunday"
	
	daysLeft.text = str(49 - days_completed) + " days remaining"
