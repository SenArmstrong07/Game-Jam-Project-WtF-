extends CanvasLayer

@onready var minimap_cam: Camera2D = %minimapCam
@onready var map_markers: Node2D = %mapMarkers
@onready var terrain_visuals: Node2D = %TerrainVisuals
@onready var marker_scene = preload("res://scenes/overworld/Marker.tscn")

var zoom_factor = 8
var markers = []
var player: Node2D
var tracked_enemies: Dictionary = {}  # Dictionary to track which enemies have markers
var frontlayer: TileMapLayer

# Minimap circle clamping
var minimap_center = Vector2.ZERO  # Updated each frame to camera position
var minimap_radius = 96  # Radius of circular minimap in pixels

# Terrain rendering
var terrain_tiles: Dictionary = {}  # Store rendered terrain tiles
var tile_size = 64  # Match the tilemap tile size
var tile_colors = {
	0: Color(0.783, 0.281, 0.469, 1.0),  # Water (blue)
	1: Color(0.527, 0.55, 0.957, 1.0),  # Land type 1 (green)
	2: Color(0.21, 0.745, 0.689, 1.0), # Land type 2 (light green)
	3: Color(0.875, 0.671, 0.295, 1.0),  # Land type 3 (lighter green)
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Get reference to player
	player = get_tree().root.get_child(0).get_node("OverworldPlayer")
	
	# Get reference to frontlayer and connect to enemy_spawned signal
	frontlayer = get_tree().root.get_child(0).get_node("TileNode/front")
	if frontlayer:
		frontlayer.enemy_spawned.connect(_on_enemy_spawned)
	
	# Set up minimap camera
	if minimap_cam:
		minimap_cam.enabled = true
		minimap_cam.zoom = Vector2(0.5, 0.5)  # Zoom out to see more terrain

func _physics_process(delta: float) -> void:
	if player:
		minimap_cam.position = player.position / zoom_factor
		minimap_center = player.position / zoom_factor  # Update center to camera position
		
		# Ensure camera is enabled
		if minimap_cam:
			minimap_cam.enabled = true
	
	# Periodically render nearby terrain chunks
	render_nearby_terrain_chunks()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_enemy_spawned(enemy: Node2D) -> void:
	# Create marker when enemy is spawned
	var marker = create_marker_for_enemy(enemy)
	tracked_enemies[enemy] = marker


func create_marker_for_enemy(enemy: Node2D) -> Sprite2D:
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
	
	return marker


func render_nearby_terrain_chunks() -> void:
	if not frontlayer or not terrain_visuals:
		return
	
	var camera_tile_pos = frontlayer.local_to_map(player.position)
	var render_range = 25  # Adjusted for smaller 192×192 viewport
	
	# Render terrain tiles in range
	for x in range(camera_tile_pos.x - render_range, camera_tile_pos.x + render_range):
		for y in range(camera_tile_pos.y - render_range, camera_tile_pos.y + render_range):
			var tile_pos = Vector2i(x, y)
			
			# Skip if already rendered
			if tile_pos in terrain_tiles:
				continue
			
			# Get altitude and determine tile type
			var altitude = frontlayer.get_altitude(x, y)
			var tile_type = 0 if altitude < 0 else int((altitude + 10) / 20.0 * 4) % 4
			
			# Render tile to minimap
			render_terrain_tile(tile_pos, tile_type)
			terrain_tiles[tile_pos] = tile_type
	
	# Clean up tiles that are too far away
	var tiles_to_remove = []
	for tile_pos in terrain_tiles:
		var dist = camera_tile_pos.distance_to(tile_pos)
		if dist > render_range + 10:
			tiles_to_remove.append(tile_pos)
	
	for tile_pos in tiles_to_remove:
		terrain_tiles.erase(tile_pos)


func render_terrain_tile(tile_pos: Vector2i, tile_type: int) -> void:
	if not terrain_visuals:
		return
		
	var rect = ColorRect.new()
	var world_pos = frontlayer.map_to_local(tile_pos) / zoom_factor
	
	rect.position = world_pos - Vector2(tile_size / 2 / zoom_factor, tile_size / 2 / zoom_factor)
	rect.size = Vector2(tile_size / zoom_factor, tile_size / zoom_factor)
	rect.color = tile_colors.get(tile_type, Color.GRAY)
	
	terrain_visuals.add_child(rect)
