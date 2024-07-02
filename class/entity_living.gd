extends Entity
class_name EntityLiving

@export var health: float
@export var inventory: Inventory

@export var damage_physic: float
@export var damage_magic: float
@export var damage_pure: float

@export var resistance_physic: float
@export var resistance_magic: float
@export var resistance_pure: float

@export var speed: float
@export var SPECIAL: Array

@export var relation: int
@export var view_distance: float
@export var hear_distance: float

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






