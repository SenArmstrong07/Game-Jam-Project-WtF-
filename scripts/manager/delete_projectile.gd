extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 500.0
var damage: int = 15
var chip: Chip = null

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

		print("DELETE hit ", body.name)

		body.take_damage(damage, Unit.DamageType.NEUTRAL, chip)

		queue_free()
