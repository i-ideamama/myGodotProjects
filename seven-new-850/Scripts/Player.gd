extends KinematicBody2D

var velocity = Vector2.ZERO
export var speed = 150
export var jump_speed = Vector2(0,-350)
export var gravity = Vector2(0,2500)
export (float, 0, 1.0) var friction = 0.1
export (float, 0, 1.0) var acceleration = 0.25

onready var ui = $UI
onready var energy_bar = (ui.get_child(0).get_child(0))
onready var happiness_bar = (ui.get_child(0).get_child(1))
onready var health_bar = (ui.get_child(0).get_child(2))
onready var animationPlayer = $AnimationPlayer
onready var PhoneTimer = $"PhoneTimer"
onready var PrintedPaper = get_parent().get_node("PrintedPaper")

onready var paper = get_parent().get_node("Paper")
onready var charger = get_parent().get_node("BossCharger")
onready var chair = get_parent().get_node("BossChair")
onready var tools = get_parent().get_node("ToolBox")
onready var staplerProg = $StaplerProgress
onready var jump = $jump

var energy = 100
var happiness = 100
var health = 100
var jump_energy = 5 # Energy spent per jump
var walking_cost = 1 # Energy spent on walk
var debug_isHappy = false
var move_in_last_4_secs

var wants_to_move = false
var current_level = 1
var floor_level = 0
var diff = 0
var elevator_speed = 2.8 # HAS TO BE A FACTOR OF 112


onready var TV_happiness_increaser = $TV_happiness_increaser
onready var Coffee_energy_increaser = $Coffee_energy_increaser

onready var sprite  = $Sprite
onready var tween = $Tween

enum ANIMATION_STATE {IDLE, WALK}
enum DIRECTION {RIGHT, LEFT}
var current_animation_state
var current_direction
var staplersCollected = 0


var tutorials ={"npc":true,"start":true,"coffee":true,"tv":true,"after-tv":true,"after-coffee":true}
# tasks
var task_list = ['Grab some paper and print the documents',
				 "Find the boss's laptop charger and give it to him",
				"Find the boss's chair",
				'Answer the phone!',
				 "Find tools and Fix the projector",
				"Your documents have been printed! Grab some staplers for your documents. Dont't worry, it wont hurt!",
				"Get the documents to the bosses desk and become the boss"
				]
var staplePapersFromPrinter = false
var ringingPhone = false
var hasPaper = false
var hasCharger = false
var hasChair = false
var bossFight = false
var hasTools = false
var collectStapler = false
var holdingPrintedPaper = false
var currHoldingObj = false
onready var PhoneTip = $"UI/Control/ColorRect"
func _ready():
	sprite.frame = 1
	PhoneTip.showMessage("start",true)

func _physics_process(delta):
	
	if wants_to_move:
		current_level = round(position.y)
		#print(getLevel(position.y))
		if current_level != floor_level:
			position.y += diff * elevator_speed
		else:
			if currHoldingObj:
				currHoldingObj.visible = true
			visible = true
			wants_to_move = false
			get_node("../YSort2/Elevator" + str(getLevel(position.y))).openDoor()
			get_node("../YSort2/Elevator" + str(getLevel(position.y)))._on_Door_Open_Area_body_entered(self)
			
	
	else:
		get_input(delta) # Takes in user input
		animate_player()
		add_gravity(gravity,delta)
		#print(happiness)

		velocity = move_and_slide(velocity, Vector2.UP)


		if happiness < 30:
			badMood()
		else:
			goodMood()

		debug_isHappy = not debug_isHappy

		if hasPaper: paper.position = Vector2(position.x - 2, position.y -32)
		if holdingPrintedPaper: PrintedPaper.position = Vector2(position.x - 2, position.y -32)
		if hasCharger: charger.position = Vector2(position.x - 2, position.y - 32)
		if hasChair: chair.position = Vector2(position.x - 2, position.y - 32)
		if hasTools: tools.position = Vector2(position.x - 2, position.y - 32)
		UpdateBars()


func _on_PhoneTimer_timeout():
	ringingPhone.deactivate()
	selectRandomPhone() # Replace with function b


func selectRandomPhone():	# 4 phons
	var debug = "../Phones/Phone" + str(floor(rand_range(1,5)))
	ringingPhone = get_node(debug)
	ringingPhone.activate()
	print(debug)



func elevateTo(n):
	if currHoldingObj:
		currHoldingObj.visible = false
	visible = false
	get_node("../YSort2/Elevator" + str(getLevel(position.y))).closeDoor()
	wants_to_move = true
	current_level = round(position.y)
	floor_level = 604 - 112 * (n - 1)
	if floor_level > current_level:
		diff = 1
	else:
		diff = -1

func getLevel(y):
	return floor(((604 - y)/112) + 1)
func animate_player():
	if current_direction == DIRECTION.RIGHT:
		if velocity.x > 10:
			animationPlayer.play("happy_player_walk_right")
		

	elif current_direction == DIRECTION.LEFT:
		if velocity.x < -10:
			animationPlayer.play("happy_player_walk_left")



func get_input(delta):
	var dir = 0
	dir = $"UI".getDir()
		
	var cost = delta * walking_cost
	if dir != 0 and energy > cost:
		happiness -= cost / 3
		move_in_last_4_secs = true
		energy -= cost
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		
	else:
		velocity.x = lerp(velocity.x, 0, friction)
	
	return dir


# Adds a force to the player
func add_gravity(F,delta): # Takes in a Vec2 and delta time
	velocity += F * delta


# To be called when player must jump
func jump():
	if is_on_floor() and energy > jump_energy:
		move_in_last_4_secs = true
		add_gravity(jump_speed,1)
		energy -= jump_energy


# To be called when happiness above threshold
func goodMood(): # NPCs stop blocking the player
	set_collision_mask_bit(2, false)
	
# To be called when happiness below threshold
func badMood(): # NPCs start blocking the player
	set_collision_mask_bit(2, true)

func getHit():
	if collectStapler:
		staplersCollected += 1
		staplerProg.Update_Bar(staplersCollected)
		staplerProg.get_child(0).text = str(staplersCollected) + "/50"
		if staplersCollected > 10:
			collectStapler = false
			staplerProg.visible = false
			staplePapersFromPrinter = true
			PrintedPaper.visible = true
		return
		
	if health - 10 > 0:
		health -= 10
		$hurt.play()
	else:
		get_parent().gameOver("Lose")


func UpdateBars():
	energy_bar.Update_Bar(energy)
	health_bar.Update_Bar(health)
	happiness_bar.Update_Bar(happiness)


func _on_energy_increase_timeout():
	if move_in_last_4_secs == false:
		if energy + 10 <= 100:
			energy += 10
	move_in_last_4_secs = false


func _on_player_area_area_entered(area):
	if "TV" in area.name:
		if tutorials["tv"]:
			PhoneTip.showMessage("tv",true)
			tutorials["tv"] = false
		TV_happiness_increaser.start()
	elif "CoffeeMaker" in area.name:
		if tutorials["coffee"]:
			PhoneTip.showMessage("coffee",true)
			tutorials["coffee"] = false
			
			
		Coffee_energy_increaser.start()
	elif area.name == "Paper":
		if hasPaper == false:
			currHoldingObj = paper
			hasPaper = true
			paper.scale = Vector2(0.5, 0.5)
	elif area.name == "Printer":
		if hasPaper:
			paper.queue_free()
			PhoneTip.showMessage("after-" + task_list[0],true)
			task_list.remove(0)
			hasPaper = false
			PhoneTip.showMessage(task_list[0],false)
			
		if staplePapersFromPrinter:
			task_list.remove(0)
			currHoldingObj = PrintedPaper
			holdingPrintedPaper = true
			bossFight = true
			PhoneTip.showMessage(task_list[0],false)
	elif area.name == "BossCharger" and task_list[0] == "Find the boss's laptop charger and give it to him":
		if hasCharger == false:
			currHoldingObj = charger
			hasCharger = true
			charger.scale = Vector2(0.5, 0.5)
	elif area.name == "Boss":
		if hasCharger:
			PhoneTip.showMessage("after-" + task_list[0],true)
			charger.queue_free()
			task_list.remove(0)
			
			hasCharger = false
			PhoneTip.showMessage(task_list[0],false)
		if hasChair:
			PhoneTip.showMessage("after-" + task_list[0],true)
			chair.position  = Vector2(1646.969, -82.725)
			task_list.remove(0)
			hasChair = false
			chair.scale = Vector2(1,1)
			PhoneTip.showMessage(task_list[0],false)
			selectRandomPhone()
			PhoneTimer.start()

	elif area.name == "BossChair" and task_list[0] == "Find the boss's chair":
		if hasChair == false:
			currHoldingObj = chair
			hasChair = true
			chair.scale = Vector2(0.25, 0.25)
		
	elif area.name == "ToolBox" and task_list[0] == "Find tools and Fix the projector":
		if hasTools == false:
			currHoldingObj = tools
			hasTools = true
			tools.scale = Vector2(0.5, 0.5)
	elif area.name == "Projector":
		if hasTools:
			PhoneTip.showMessage("after-" + task_list[0],true)
			
			tools.queue_free()
			task_list.remove(0)
			hasTools = false
			PhoneTip.showMessage(task_list[0],false)
			collectStapler = true
			staplerProg.visible = true
	elif "Phone" in area.name:
		if area.isActive:
			area.deactivate()
			PhoneTimer.stop()
			
			if task_list[0] == 'Answer the phone!':
				PhoneTip.showMessage("after-" + task_list[0],true)
				task_list.remove(0)
				PhoneTip.showMessage(task_list[0],false)
	
	elif bossFight and area.name == "BossChair":
		get_parent().gameOver("Win")
	

func _on_player_area_area_exited(area):
	if "TV" in area.name:
		TV_happiness_increaser.stop()
		if tutorials["after-tv"]:
			PhoneTip.showMessage("after-tv",true)
			tutorials["after-tv"] = false
	elif "CoffeeMaker" in area.name:
		
		Coffee_energy_increaser.stop()
		if tutorials["after-coffee"]:
			PhoneTip.showMessage("after-coffee",true)
			tutorials["after-coffee"] = false
			PhoneTip.showMessage(task_list[0],false)


func _on_idle_energy_increaser_timeout():
	if move_in_last_4_secs == false:
		if energy + 10 <= 100:
			energy += 10
	move_in_last_4_secs = false


func _on_TV_happiness_increaser_timeout():
	if happiness + 1 <= 100:
		happiness += 1
	if happiness + 1 > 100:
		happiness = 100
	
	if health + 0.5 <= 100:
		health += 0.5
	if health + 0.5 > 100:
		health = 100
	
		

func _on_Coffee_energy_increaser_timeout():
	if energy + 1 <= 100:
		energy += 1
	if energy + 1 > 100:
		energy = 100
	
	if health + 0.5 <= 100:
		health += 0.5
	if health + 0.5 > 100:
		health = 100
		



func _on_AnimationPlayer_animation_finished(_not_used):
	if current_direction == DIRECTION.RIGHT:
		if velocity.x <= 10:
				animationPlayer.play("happy_player_idle_right")
	
	
	if current_direction == DIRECTION.LEFT:
		if velocity.x > -10:
			animationPlayer.play("happy_player_idle_left")



func _on_player_area_body_entered(body):
	if "NPC" in body.name and tutorials["npc"]:
		PhoneTip.showMessage("npc",true) # Replace with function body.
		tutorials["npc"] = false
