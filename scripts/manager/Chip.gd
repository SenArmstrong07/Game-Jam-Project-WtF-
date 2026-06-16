extends Resource
class_name Chip

@export var name: String
@export var damage_type: Unit.DamageType = Unit.DamageType.NEUTRAL
@export var power: int = 10
@export var range_tile: int = 1
@export var description: String = ""

func _init(p_name: String = "", p_damage_type: Unit.DamageType = Unit.DamageType.NEUTRAL, 
		   p_power: int = 10, p_range: int = 1, p_description: String = "") -> void:
	name = p_name
	damage_type = p_damage_type
	power = p_power
	range_tile = p_range
	description = p_description

func clone_chip() -> Chip:
	var copy = duplicate(true) as Chip
	return copy
