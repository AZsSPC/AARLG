extends TileMap

var random = RandomNumberGenerator.new()

func _ready():
	random.randomize()
	generate_map()

func generate_map():
	clear()
	
	var cells = []
	for x in 30:
		for y in 30:
			cells.append(Vector2i(x, y))
		
	set_cells_terrain_connect(0, cells, 0, 1)
	
	cells = []
	for x in 10:
		for y in 10:
			cells.append(Vector2i(x, y))
		
	set_cells_terrain_connect(0, cells, 0, 0)
