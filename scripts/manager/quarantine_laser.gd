extends Area2D

var direction: Vector2 = Vector2.RIGHT
var speed: float = 900.0
var damage: int = 10
var stun_duration: float = 2.0
var chip: Chip = null

var hit := false

func _ready():
	body_entered.connect(_on_body_entered)

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):
	if hit:
		return

	if body is Unit:
		hit = true

		body.take_damage(damage, Unit.DamageType.NEUTRAL, chip)

		if body.has_method("apply_stun"):
			body.apply_stun(stun_duration)

		queue_free()
