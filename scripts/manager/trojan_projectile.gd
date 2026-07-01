extends Area2D

@export var speed := 550.0

var direction := Vector2.LEFT
var damage := 20

var shooter: Unit = null
var hit := false

func _ready():
	body_entered.connect(_on_body_entered)
	add_to_group("enemy_projectiles")
	
	

func _process(delta):
	position += direction * speed * delta

func _on_body_entered(body):

	if hit:
		return

	if !(body is Unit):
		return

	# Ignore the shooter itself
	if body == shooter:
		return

	# Ignore teammates
	if shooter != null and body.team == shooter.team:
		return

	hit = true

	body.take_damage(damage)

	queue_free()
