extends Resource
class_name SPECIAL

@export var strength := 0
@export var perception := 0
@export var endurance := 0
@export var charisma := 0
@export var intelligence := 0
@export var agility := 0
@export var luck := 0

func set_values(strength, perception, endurance, charisma, intelligence, agility, luck):
	self.strength = strength
	self.perception = perception
	self.endurance = endurance
	self.charisma = charisma
	self.intelligence = intelligence
	self.agility = agility
	self.luck = luck
	
func _on_interact():
	pass
