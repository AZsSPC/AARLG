# Goblin.gd
extends EntityLiving

var move_timer: Timer

func _ready():
	super._ready()
	# Create and start the timer for changing direction
	move_timer = Timer.new()
	move_timer.wait_time = .5  # Change direction every 2 seconds
	move_timer.one_shot = false
	move_timer.autostart = true
	add_child(move_timer)
	move_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _on_timer_timeout():
	# Set the target position based on the direction and current position
	velocity = Vector2(randf() * 2 - 1, randf() * 2 - 1).normalized() * speed

func _physics_process(delta):
	# Move towards the target position smoothly
	move_and_slide()
