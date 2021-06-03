extends TileMap


onready var generator = get_parent().get_child(0)

var chunks_to_render
var starting_chunk = 1

func _ready():
	chunks_to_render = [generator.get_chunk(starting_chunk)]
	
	var addedChunks = 0
	while addedChunks < generator.settings.chunkBuffer:
		chunks_to_render.push_back(generator.get_chunk(starting_chunk + addedChunks))
		addedChunks += 1
		chunks_to_render.push_front(generator.get_chunk(starting_chunk - addedChunks))
		addedChunks += 1
	
	render_chunks()
	
func render_chunks():
	var file = File.new()
	file.open("res://JSON_files/chunks.json",File.WRITE)
	file.store_line(JSON.print(chunks_to_render))
	file.close()
	
	var len_of_chunk_left_of_starting_chunk = (starting_chunk - 1 - generator.settings.chunkBuffer) * generator.settings.chunkSize * generator.settings.populatorSettings.land.mult
	for world in chunks_to_render:
		for i in range(len(world.land)):
			set_cell(len_of_chunk_left_of_starting_chunk,world.land[i],0)

			for j in range(world.land[i] + 1,world.land[i] + 100):
				set_cell(len_of_chunk_left_of_starting_chunk,j,0)
			len_of_chunk_left_of_starting_chunk += 1
	
	len_of_chunk_left_of_starting_chunk = (starting_chunk - 1 - generator.settings.chunkBuffer) * generator.settings.chunkSize * generator.settings.populatorSettings.land.mult
	for world2 in chunks_to_render:
		for j in range(len(world2.caves)):
			set_cell(len_of_chunk_left_of_starting_chunk,world2.caves[j],-1)
			
			var rng = RandomNumberGenerator.new()
			rng.randomize()
			var random_cave_height = rng.randi_range(4,10)

			for c_h in range(world2.caves[j] - random_cave_height, world2.caves[j]):
				set_cell(len_of_chunk_left_of_starting_chunk,c_h,-1)
			
			
			len_of_chunk_left_of_starting_chunk += 1
			
			
func unrender_chunk(chunk,n):
	var len_of_chunk_left_of_starting_chunk = (n - 1) * generator.settings.chunkSize * generator.settings.populatorSettings.land.mult
	
	for i in range(len(chunk.land)):
		set_cell(len_of_chunk_left_of_starting_chunk,chunk.land[i],-1)
		for j in range(chunk.land[i] + 1,chunk.land[i] + 50):
			set_cell(len_of_chunk_left_of_starting_chunk,j,-1)
		len_of_chunk_left_of_starting_chunk += 1

func add_chunk_to_right():
	chunks_to_render.push_back(generator.get_chunk(starting_chunk + generator.settings.chunkBuffer + 1))
	unrender_chunk(chunks_to_render.pop_front(),starting_chunk - generator.settings.chunkBuffer)
	starting_chunk += 1
	render_chunks()

func add_chunk_to_left():
	chunks_to_render.push_front(generator.get_chunk(starting_chunk - generator.settings.chunkBuffer - 1))
	unrender_chunk(chunks_to_render.pop_back(),starting_chunk + generator.settings.chunkBuffer)
	starting_chunk -= 1
	render_chunks()
