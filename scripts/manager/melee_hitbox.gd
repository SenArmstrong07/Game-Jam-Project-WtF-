extends Area2D

var damage: int = 10
var source_unit: Unit
var lifetime := 0.1

func _ready():
	body_entered.connect(_on_body_entered)

	await get_tree().create_timer(lifetime).timeout
	queue_free()

func _on_body_entered(body):
	if body == source_unit:
		return

	if body is Unit:
		body.take_damage(damage)
