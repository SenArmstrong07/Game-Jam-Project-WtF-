extends Area2D

var direction := Vector2.LEFT
var speed := 500.0

func _process(delta):
	position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
