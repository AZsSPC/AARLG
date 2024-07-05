extends Entity
class_name EntityLiving

@export var health: int
@export var inventory: Inventory

@export var damage_physic: int
@export var damage_magic: int
@export var damage_pure: int

@export var resistance_physic: int
@export var resistance_magic: int
@export var resistance_pure: int

@export var speed: int
@export var special := SPECIAL

@export var relation: int
@export var view_distance: int
@export var hear_distance: int

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






