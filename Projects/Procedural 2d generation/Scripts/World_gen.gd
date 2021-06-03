extends Node

var settings
var SettingsFile = "res://JSON_files/settings.json"

var landNoise = OpenSimplexNoise.new()
var caveNoise = OpenSimplexNoise.new()
var mult = 3
var cave_depth = 30

func getSettings():
	var file = File.new()
	file.open(SettingsFile, File.READ)
	var content = file.get_as_text()
	file.close()
	return JSON.parse(content).result

func _ready():
	settings = getSettings()
	
	set_land_noise_variables()
	set_cave_noise_variables()
	
func get_chunk(n):
	n-=1
	var landChunk = new_land_chunk(n * settings.chunkSize * mult)
	var caveChunk = new_cave_chunk(n * settings.chunkSize * mult)
	return {"land" : landChunk, "caves" : caveChunk}


func new_land_chunk(offset):
	var sizeX = settings.chunkSize
	var chunk = []
	
	for x in range(sizeX * 3):
		var i = landNoise.get_noise_1d((x + offset)/3)
		i = abs(i)
		i*=50
		i = floor(i)
		chunk.push_back(i)
	return(chunk)

func new_cave_chunk(offset):
	var sizeX = settings.chunkSize
	var cave = []
	
	for x in range(sizeX * settings.populatorSettings.land.mult):
		var i = caveNoise.get_noise_1d((x + offset)/3)
		i = abs(i)
		i*=50
		i = floor(i)
		cave.push_back(i+30)
	return(cave)
	

func set_land_noise_variables():
	landNoise.seed = settings.populatorSettings.land.seed; # sets seed
	landNoise.octaves = settings.populatorSettings.land.octaves; # sets octave
	landNoise.period = settings.populatorSettings.land.period; # sets period
	landNoise.persistence = settings.populatorSettings.land.persistence; # sets persistence 
func set_cave_noise_variables():
	caveNoise.seed = settings.populatorSettings.caves.seed; # sets seed
	caveNoise.octaves = settings.populatorSettings.caves.octaves; # sets octave
	caveNoise.period = settings.populatorSettings.caves.period; # sets period
	caveNoise.persistence = settings.populatorSettings.caves.persistence; # sets persistence 
