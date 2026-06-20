extends Sprite2D


var zoom_factor = 8
var enemy: Node2D = null

func update_position(pos):
	global_position = pos / zoom_factor

func set_enemy(enemy_ref: Node2D) -> void:
	enemy = enemy_ref

func delete_marker():
	call_deferred("queue_free")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# Continuously update marker position based on enemy position
	if enemy:
		update_position(enemy.position)
