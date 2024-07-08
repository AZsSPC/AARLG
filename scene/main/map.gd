extends TileMap

var random = RandomNumberGenerator.new()

@export var width = 200
@export var height = 100
@export var seed = 1

const CELL = {
	"WALL": 0,
	"FLOOR": 1,
	"NEXT_LEVEL": 0,
	"PREVIOUS_LEVEL": 0,
	"FILLER": 0,
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
		return x < other.x + other.width and x + width > other.x and y < other.y + other.height and y + height > other.y

func _ready():
	generate(seed, width, height)
	

func generate(seed = 0, width = 100, height = 50):
	random.seed = seed
	clear()

	# Создаем карту, заполненную стенами
	var map = []
	for y in range(height):
		var row = []
		for x in range(width):
			row.append(CELL.WALL)
		map.append(row)

	# Создаем комнаты
	var rooms = []
	for i in range(20):
		var room = generate_room(height, width)
		if not is_room_valid(room, rooms, map):
			continue
		rooms.append(room)
		carve_room(room, map)

	for i in range(3):
		var open_room = generate_open_room(height, width)
		if not is_room_valid(open_room, rooms, map):
			continue
		rooms.append(open_room)
		carve_room(open_room, map)

	# Соединяем комнаты
	for i in range(rooms.size() - 1):
		connect_rooms(rooms[i], rooms[i + 1], map)

	# Заменяем изолированные стены на "наполнитель"
	for y in range(height):
		for x in range(width):
			if map[y][x] == CELL.WALL and is_isolated_wall(y, x, map):
				map[y][x] = CELL.FILLER

	# Добавляем вход и выход
	var entrance_room = rooms[random.randi_range(0, rooms.size() - 1)]
	var entrance = get_random_point_in_room(entrance_room)
	map[entrance.y][entrance.x] = CELL.NEXT_LEVEL
	$player.position = entrance*32

	var exit_room
	while true:
		exit_room = rooms[random.randi_range(0, rooms.size() - 1)]
		if exit_room != entrance_room:
			break

	var exit = get_random_point_in_room(exit_room)
	map[exit.y][exit.x] = CELL.PREVIOUS_LEVEL
	"""
		# Создаем теневую карту
		var shadow = []
		for y in range(height):
			var row = []
			for x in range(width):
				row.append(CELL.FILLER)
			shadow.append(row)
	"""
	var groups = [[],[],[],[],[],[]]
	for y in range(map.size()):
		for x in range(map[y].size()):
			groups[map[y][x]].append(Vector2i(x, y))
	
	for f in CELL.keys():
		set_cells_terrain_connect(0, groups[CELL[f]], 0, CELL[f])

func generate_room(map_height, map_width):
	var room_height = random.randi_range(10, 20)  # Увеличен размер комнат
	var room_width = random.randi_range(15, 30)  # Увеличен размер комнат
	var y = random.randi_range(1, map_height - room_height - 1)
	var x = random.randi_range(1, map_width - room_width - 1)
	return Room.new(x, y, room_width, room_height)

func generate_open_room(map_height, map_width):
	var room_height = random.randi_range(15, 25)  # Увеличен размер открытых комнат
	var room_width = random.randi_range(25, 35)  # Увеличен размер открытых комнат
	var y = random.randi_range(1, map_height - room_height - 1)
	var x = random.randi_range(1, map_width - room_width - 1)
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

	# Создаем коридоры шириной в 3 клетки
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

func is_isolated_wall(y, x, map):
	if map[y][x] != CELL.WALL:
		return false

	var has_floor_nearby = false
	for y_offset in range(-1, 2):
		for x_offset in range(-1, 2):
			var ny = y + y_offset
			var nx = x + x_offset

			if ny < 0 or ny >= map.size() or nx < 0 or nx >= map[0].size():
				continue
			if map[ny][nx] == CELL.FLOOR:
				has_floor_nearby = true
				break

		if has_floor_nearby:
			break

	return not has_floor_nearby
