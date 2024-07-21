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
