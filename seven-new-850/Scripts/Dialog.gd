extends TextureRect

export var dialogPath = "res://dialog-final.json"
export(float) var textSpeed = 0.05

var dialog

var isOpen = false

var finish = false
func _ready():
	$"textSpeedTimer".wait_time = textSpeed
	dialog = getDialog()
	assert(dialog, 'dialog not found')
	#showMessage("Your documents have been printed! Grab some staplers for your documents. Dont't worry, it wont hurt!")
	
	
	

var running = false
	
func _showMessage(messagess):
	running = true
	for messages in messagess:
		$name.bbcode_text = messages["name"]
		
		var textPart = messages["text"] + "\n"
		var ttodo = messages.get("TasksToDo")
		if ttodo:
			for i in ttodo:
				textPart += " -" + i + "\n"
		
		$text.bbcode_text = textPart

		$text.visible_characters = 0

		while $text.visible_characters < len($text.text):
			$text.visible_characters += 1

			$textSpeedTimer.start()
			yield($textSpeedTimer, "timeout")
	running = false	
	if len(stack) > 0:
		
		showMessage(stack[0][0],stack[0][1])
		
		stack.pop_back() 
var stack = []

func showMessage(event,getPhoneUp):
	print(event,getPhoneUp)
	if running:
		stack.push_back([event,getPhoneUp])
		return
	var messages = dialog.get(event)
	if getPhoneUp:
		ascendPhone()
	if messages:
		_showMessage(messages)
		

	
func getDialog():
	var f = File.new()
	assert(f.file_exists(dialogPath), 'file does not exist')
	
	f.open(dialogPath, File.READ)
	var json = f.get_as_text()
	
	var output = parse_json(json)
	
	return output


#func nextPhrase():
#
#
#	finished = false
#
#	$name.bbcode_text = dialog[phraseNum]["name"]
#	$text.bbcode_text = dialog[phraseNum]["text"]
#
#	$text.visible_characters = 0
#
#	while $text.visible_characters < len($text.text):
#		$text.visible_characters += 1
#
#		$textSpeedTimer.start()
#		yield($textSpeedTimer, "timeout")
#
#	finished = true
#	phraseNum += 1
func descendPhone():
	isOpen = false
	rect_position.y = 180
	
func ascendPhone():
	isOpen = true
	rect_position.y = -6

func _on_Button_pressed():
	if not isOpen:
		ascendPhone()
	else:
		descendPhone()
