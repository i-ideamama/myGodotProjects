extends Node2D

onready var TileMap = $TileMap

var chunk_width = 16

var land_noise  = OpenSimplexNoise.new()
var land_list = []
var tile_width = 64

func _ready():
	setup_land_gen()
	for i in range(0,5):
		land_list.append(floor(land_noise.get_noise_1d(i) * 100) * -1)
	print(land_list)


func gen_start_chunks():
	for block in range(0,chunk_width):
		TileMap.set_cell()


func setup_land_gen():
	land_noise.seed = 0
	land_noise.octaves = 2
	land_noise.period = 64.0
	land_noise.persistence = 0.8

