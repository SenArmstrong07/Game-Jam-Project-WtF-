extends Node2D
class_name TitleScreen
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var button_manager: Control = $Button_Manager
@onready var click_tag: Label = $ClickTag
var waiting_for_click : bool = true
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	button_manager.visible = false
	click_tag.visible = false
	
	#play animation first
	animation_player.play("black_in")
	animation_player.advance(0)
	await animation_player.animation_finished
	
	click_tag.visible = true
	animation_player.play("Blink")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		show_menu()

func show_menu() -> void:
	waiting_for_click = false
	animation_player.stop()
	click_tag.visible = false
	button_manager.visible = true


func _on_start_pressed() -> void:
	print("START PRESSED")


func _on_settings_pressed() -> void:
	print("SETTINGS PRESSED")


func _on_quit_pressed() -> void:
	get_tree().quit()
