extends EntityLiving
class_name EntityPlayer

func _ready():
	super._ready()
	Global.player = self

func get_input():
	var direction = Vector2.ZERO

	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("move_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_left")  or Input.is_action_pressed("move_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_down")  or Input.is_action_pressed("move_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_up")    or Input.is_action_pressed("move_up"):
		direction.y -= 1

	if direction != Vector2.ZERO:
		direction = direction.normalized()

	return direction

func _physics_process(delta):
	velocity = get_input() * speed
	move_and_slide()

func set_limit(x, y):
	$camera.limit_top = -64
	$camera.limit_left = 32
	$camera.limit_right = x - 32
	$camera.limit_bottom = y - 96

func get_visible_chunks(chunk_size, top_limit):
	var screen_size = $camera.get_viewport_rect().size
	var zoom = $camera.zoom
	var half_screen_size = screen_size * 0.5

	var from = Vector2i(global_position - half_screen_size) / 32 / chunk_size
	from.x = max(0, min(from.x, top_limit.x))
	from.y = max(0, min(from.y, top_limit.y))
	var to = Vector2i(global_position + half_screen_size) / 32 / chunk_size
	to.x = max(0, min(to.x, top_limit.x))
	to.y = max(0, min(to.y, top_limit.y))

	return [from, to]
