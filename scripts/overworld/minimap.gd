extends CanvasLayer

@onready var minimap_cam: Camera2D = %minimapCam
@onready var map_markers: Node2D = %mapMarkers
@onready var marker_scene = preload("res://scenes/overworld/Marker.tscn")

var zoom_factor = 8
var player: Node2D
var tracked_enemies: Dictionary = {}  # Dictionary to track which enemies have markers
var frontlayer: TileMapLayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get reference to player
	player = get_tree().root.get_child(0).get_node("OverworldPlayer")
	
	# Get reference to frontlayer and connect to enemy_spawned signal
	frontlayer = get_tree().root.get_child(0).get_node("TileNode/front")
	if frontlayer:
		frontlayer.enemy_spawned.connect(_on_enemy_spawned)

func _physics_process(delta: float) -> void:
	if player:
		minimap_cam.position = player.position / zoom_factor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_spawned(enemy: Node2D) -> void:
	# Create marker when enemy is spawned
	create_marker_for_enemy(enemy)
	tracked_enemies[enemy] = true


func create_marker_for_enemy(enemy: Node2D) -> void:
	var marker = marker_scene.instantiate()
	
	# Link marker to enemy for continuous position updates
	marker.set_enemy(enemy)
	
	# Set initial position immediately to avoid visual glitch
	marker.update_position(enemy.position)
	
	map_markers.add_child(marker)
	
	# Connect death signal if it exists
	if enemy.has_signal("died"):
		enemy.died.connect(marker.delete_marker)
		enemy.died.connect(func(): tracked_enemies.erase(enemy))
