extends Unit

@onready var anim_player: AnimatedSprite2D = $BossSC_Sprite
@onready var battle_scene: BattleBase = get_parent()

const GRID_WIDTH := 4
const GRID_HEIGHT := 4
const TILE_SIZE := 64
const X_OFFSET := 4

var attack_timer := 0.0
var attack_interval := 1.5

var movement_locked := true  # boss never moves

# ============================================================
# INIT
# ============================================================
func _ready():
	z_index = 10
	team = Team.ENEMY
	add_to_group("enemies")

	# BIG boss stats (override Unit defaults)
	max_hp = 500
	hp = max_hp
	attack_power = 20

# ============================================================
# GRID SETUP (IMPORTANT)
# ============================================================
func init(pos: Vector2i) -> void:
	grid_pos = pos

	_reserve_tiles(true)

	position = get_boss_center_world()

func get_boss_center_world() -> Vector2:
	var top_left = grid_pos

	var center_tile = Vector2(
		top_left.x + 0.5,
		top_left.y + 0.5
	)

	return Vector2(
		(center_tile.x + X_OFFSET) * TILE_SIZE + TILE_SIZE / 2.0,
		center_tile.y * TILE_SIZE + TILE_SIZE / 2.0
	)
	
# ============================================================
# TILE OCCUPATION (4 TILES)
# ============================================================
func get_occupied_tiles(center: Vector2i) -> Array[Vector2i]:
	return [
		center,
		center + Vector2i.RIGHT,
		center + Vector2i.DOWN,
		center + Vector2i(1, 1)
	]

func _reserve_tiles(state: bool) -> void:
	for t in get_occupied_tiles(grid_pos):
		if state:
			battle_scene.occupied_tiles[t] = true
		else:
			battle_scene.occupied_tiles.erase(t)

# ============================================================
# WORLD POSITION (CENTER OF 2x2)
# ============================================================
func grid_to_world(cell: Vector2i) -> Vector2:
	var world_grid_x = cell.x + X_OFFSET

	return Vector2(
		world_grid_x * TILE_SIZE + TILE_SIZE / 2.0,
		cell.y * TILE_SIZE + TILE_SIZE / 2.0
	)

# ============================================================
# PROCESS (ONLY ATTACKS, NO MOVEMENT)
# ============================================================
func _process(delta):
	if battle_scene.current_phase != BattleBase.BattlePhase.BATTLE:
		return

	if is_dead:
		return

# ============================================================
# SIMPLE BOSS ATTACK
# ============================================================
