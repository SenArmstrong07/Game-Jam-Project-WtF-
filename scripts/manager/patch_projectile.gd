extends Area2D

var target: Unit
var damage: int = 10
var chip: Chip = null
var speed := 300.0

@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready():
	particles.emitting = true

func _process(delta):
	if target == null:
		queue_free()
		return

	var dir = global_position.direction_to(target.global_position)

	# Smoothly rotate toward target
	rotation = lerp_angle(
		rotation,
		dir.angle(),
		8.0 * delta
	)

	# Move toward target
	global_position += dir * speed * delta

	# Hit target
	if global_position.distance_to(target.global_position) < 10:
		target.take_damage(damage, Unit.DamageType.NEUTRAL, chip)
		queue_free()
