extends Area2D

@export var speed := 600.0

var direction := Vector2.RIGHT
var damage := 0
var chip: Chip

var hit_target := false

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):

	if hit_target:
		return

	if body is Unit:

		hit_target = true

		print("REFORMAT hit ", body.name)

		body.take_damage(
			damage,
			Unit.DamageType.NEUTRAL,
			chip
		)

		queue_free()
