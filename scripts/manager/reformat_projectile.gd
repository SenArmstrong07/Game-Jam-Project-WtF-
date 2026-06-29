extends Area2D

@export var speed := 700.0

var direction := Vector2.RIGHT
var damage := 0
var chip: Chip

func _ready():
	print("REFORMAT SPAWNED")
	
func _physics_process(delta):
	position += direction * speed * delta
	print(position)

func _on_body_entered(body):
	print("COLLIDED WITH:", body.name)

	if body is Unit:
		print("DAMAGING")
		body.take_damage(damage, Unit.DamageType.NEUTRAL, chip)
		queue_free()
