extends TileMap

var random = RandomNumberGenerator.new()

var chunk_size = 16
@export var width = chunk_size * 6
@export var height = chunk_size * 6
@export var seed = 1
@export var min_rooms = 5
@export var max_rooms = 10
@export var map = []
var loaded_chunks = []

const CELL = {
	"WALL": 0,
	"FLOOR": 1,
	"NEXT_LEVEL": 3,
	"PREVIOUS_LEVEL": 2
}

class Room:
	var x
	var y
	var width
	var height

	func _init(x, y, width, height):
		self.x = x
		self.y = y
		self.width = width
		self.height = height

	func intersects(other):
		return \
		x < other.x + other.width and \
		x + width > other.x and \
		y < other.y + other.height and \
		y + height > other.y

func _ready():
	Global.player.set_limit(width * 32, height * 32)
	Global.player.position = generate(seed) * 32
	update_map()
	
func _process(delta):
	pass
	#update_chunks()

func generate(seed = 1):
	random.seed = seed

	# Create map filled with walls
	map = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(CELL.WALL)
		map.append(row)

	# Create rooms
	var rooms = []
	var room_count = random.randi_range(5, 10)
	for i in range(room_count):
		var room = generate_room(height, width)
		if not is_room_valid(room, rooms, map):
			continue
		rooms.append(room)
		carve_room(room, map)

	# Connect rooms
	for i in range(rooms.size() - 1):
		connect_rooms(rooms[i], rooms[i + 1], map)

	# Add entrance and exit
	var entrance_room = rooms[random.randi_range(0, rooms.size() - 1)]
	var entrance = get_random_point_in_room(entrance_room)
	map[entrance.y][entrance.x] = CELL.NEXT_LEVEL

	var exit_room
	while true:
		exit_room = rooms[random.randi_range(0, rooms.size() - 1)]
		if exit_room != entrance_room:
			break

	var exit = get_random_point_in_room(exit_room)
	map[exit.y][exit.x] = CELL.PREVIOUS_LEVEL
	
	loaded_chunks = []
	for y in range(height / chunk_size):
		loaded_chunks.append([])
		for x in range(width / chunk_size):
			loaded_chunks[y].append(false)

	print('chunks w=%s h=%s' % [loaded_chunks[0].size(), loaded_chunks.size()])
	return entrance

func update_chunks():
	var vch = Global.player.get_visible_chunks(chunk_size, Vector2i(width / 16 + 1, height / 16 + 1))
	var do_draw = false
	var groups = []
	for f in CELL.keys():
		groups.append([])

	for y in range(vch[0].y, vch[1].y + 1):
		for x in range(vch[0].x, vch[1].x + 1):
			if loaded_chunks[y][x]: continue
			print('loaded x:%s y:%s' % [x, y])

			for yi in range(y * chunk_size, y * chunk_size + chunk_size):
				for xi in range(x * chunk_size, x * chunk_size + chunk_size):
					groups[map[yi][xi]].append(Vector2i(xi, yi))

			do_draw = true
			loaded_chunks[y][x] = true

	if do_draw: for f in CELL.keys():
		set_cells_terrain_connect(0, groups[CELL[f]], 0, CELL[f])

func update_map():
	var groups = []
	for f in CELL.keys():
		groups.append([])
	
	for y in range(height):
		#var p = ''
		for x in range(width):
			#p += '#' if map[y][x] == CELL.WALL else ' ' if map[y][x] == CELL.FLOOR else '?'
			groups[map[y][x]].append(Vector2i(x, y))
			if map[y][x] == CELL.PREVIOUS_LEVEL:
				Global.player.position = Vector2(x, y) * 32
		#print(p)
	
	clear()
	for f in CELL.keys():
		set_cells_terrain_connect(0, groups[CELL[f]], 0, CELL[f])

func generate_room(map_height, map_width):
	var room_height = random.randi_range(4, 10)
	var room_width = random.randi_range(4, 10)
	var y = random.randi_range(3, map_height - room_height - 4)
	var x = random.randi_range(3, map_width - room_width - 4)
	return Room.new(x, y, room_width, room_height)

func is_room_valid(room, rooms, map):
	for r in rooms:
		if room.intersects(r):
			return false
	return true

func carve_room(room, map):
	for y in range(room.y, room.y + room.height):
		for x in range(room.x, room.x + room.width):
			map[y][x] = CELL.FLOOR

func connect_rooms(room1, room2, map):
	var point1 = get_random_point_in_room(room1)
	var point2 = get_random_point_in_room(room2)

	var y = point1.y
	var x = point1.x

	while x != point2.x:
		for i in range(-1, 2):
			map[y + i][x] = CELL.FLOOR
		x += 1 if x < point2.x else -1

	while y != point2.y:
		for i in range(-1, 2):
			map[y][x + i] = CELL.FLOOR
		y += 1 if y < point2.y else -1

func get_random_point_in_room(room):
	var y = random.randi_range(room.y, room.y + room.height - 1)
	var x = random.randi_range(room.x, room.x + room.width - 1)
	return Vector2i(x, y)

func trim_map():
	var top_trim:int = 3
	var bottom_trim:int = 3
	var left_trim:int = 3
	var right_trim:int = 3

	# Trim top
	while true:
		var is_wall_row = true
		for cell in map[top_trim]:
			if cell != CELL.WALL:
				is_wall_row = false
				break
		if not is_wall_row:
			break
		map.remove_at(top_trim)

	# Trim bottom
	while true:
		var is_wall_row = true
		for cell in map[-bottom_trim - 1]:
			if cell != CELL.WALL:
				is_wall_row = false
				break
		if not is_wall_row:
			break
		map.remove_at(map.size() - bottom_trim - 1)

	# Trim left
	while true:
		var is_wall_column = true
		for row in map:
			if row[left_trim] != CELL.WALL:
				is_wall_column = false
				break
		if not is_wall_column:
			break
		for row in map:
			row.remove_at(left_trim)

	# Trim right
	while true:
		var is_wall_column = true
		for row in map:
			if row[-right_trim - 1] != CELL.WALL:
				is_wall_column = false
				break
		if not is_wall_column:
			break
		for row in map:
			row.remove_at(row.size() - right_trim - 1)

	print('old  w=%s h=%s' % [width, height])
	width = map[0].size()
	height = map.size()
	print('new  w=%s h=%s' % [width, height])
	
	Global.player.set_limit(width * 32, height * 32)
