extends Entity
class_name EntityLiving

@export var id := 'entity_living'

@export var inventory: Inventory
@export var relation := 0

@export_group('Stats')
@export var health := 100
@export var speed := 150
@export_subgroup('Special')
@export var strength := 0
@export var perception := 0
@export var endurance := 0
@export var charisma := 0
@export var intelligence := 0
@export var agility := 0
@export var luck := 0

@export_group('View')
@export var view_distance := 15
@export var view_angle := 70
@export var view_direction := Vector2(0, 1)
@export_group('Hearing')
@export var hear_distance := 30

@export_group('Damage')
@export var damage_physic := 0
@export var damage_magic := 0
@export var damage_pure := 0

@export_group('Resistance')
@export var resistance_physic := 0
@export var resistance_magic := 0
@export var resistance_pure := 0

func _ready():
	print(id)

func on_interact():
	pass

func deal_damage(target: EntityLiving):
	pass

func take_damage(dealer: EntityLiving):
	pass

func move(direction: Vector2):
	pass

func attack():
	pass

func interact():
	pass

func death_rattle():
	pass






