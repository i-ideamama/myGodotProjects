extends Node2D


var SettingsFile = "res:///settings.png"

func _ready():
	$text.text = str(getSettings())
	print(getSettings())
	
func getSettings():
	var file = File.new()
	file.open(SettingsFile, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).result
