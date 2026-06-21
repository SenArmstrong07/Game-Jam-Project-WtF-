extends Area2D

var target: Unit
var damage: int = 10
var chip: Chip = null
var speed := 300.0

func _process(delta):
	if target == null:
		queue_free()
		return

	global_position = global_position.move_toward(
		target.global_position,
		speed * delta
	)

	if global_position.distance_to(target.global_position) < 10:
		target.take_damage(damage, Unit.DamageType.NEUTRAL, chip)
		queue_free()
