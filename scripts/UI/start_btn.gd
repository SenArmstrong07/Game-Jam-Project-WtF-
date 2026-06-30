extends TextureButton
class_name StartButton

@onready var start_label: Label = $StartLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_label.add_theme_color_override("font_color", Color.WHITE)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_mouse_entered() -> void:
	print("START HOVERED")
	start_label.add_theme_color_override("font_color", Color.YELLOW)


func _on_mouse_exited() -> void:
	start_label.add_theme_color_override("font_color", Color.WHITE)
