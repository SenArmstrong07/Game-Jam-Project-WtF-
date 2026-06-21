extends Node2D

@onready var sprite: Sprite2D = $Sprite2D

func set_hit(is_hit: bool) -> void:
	if is_hit:
		sprite.modulate = Color.GREEN
	else:
		sprite.modulate = Color.RED
