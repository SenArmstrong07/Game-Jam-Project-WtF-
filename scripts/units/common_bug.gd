extends Unit

@onready var anim_player: AnimatedSprite2D = $AnimatedSprite2D
const EnemyBasicProjectile = preload("res://scenes/Attacks/enemy_basic_projectile.tscn")
@onready var ProjectileShootPoint: Marker2D = $Marker2D
@onready var player_character = $"../PlayerCharacter"
@onready var battle_scene : Battlescene = $".."


const GRID_WIDTH := 4
const GRID_HEIGHT := 4
const X_OFFSET := 4 
const TILE_SIZE := 64

var target_position := Vector2.ZERO

var follow_timer := 0.0
var follow_interval := 1.0
var shoot_timer := 0.0
var shoot_interval := 1.0

var move_speed := 200.0

func _ready():
	position = grid_to_world(grid_pos)
	grid_x = grid_pos.x
	grid_y = grid_pos.y
	target_position = position 


func grid_to_world(cell: Vector2i) -> Vector2:
	var world_grid_x = cell.x + X_OFFSET

	return Vector2(
		world_grid_x * TILE_SIZE + TILE_SIZE / 2.0,
		cell.y * TILE_SIZE + TILE_SIZE / 2.0
	)

func _process(delta):
	if battle_scene.current_phase != Battlescene.BattlePhase.BATTLE:
		return
	shoot_timer += delta
	follow_timer += delta

	if follow_timer >= follow_interval:
		follow_timer = 0.0
		follow_player()

	position = position.move_toward(
		target_position,
		move_speed * delta
	)
	if shoot_timer >= shoot_interval:
		shoot_timer = 0

		if player_in_front():
			shoot()

func follow_player():
	if player_character == null:
		return

	var player_row = player_character.grid_pos.y

	if player_row > grid_pos.y:
		grid_pos.y += 1
	elif player_row < grid_pos.y:
		grid_pos.y -= 1
	else:
		return

	grid_pos.y = clamp(grid_pos.y, 0, GRID_HEIGHT - 1)

	grid_x = grid_pos.x
	grid_y = grid_pos.y

	target_position = grid_to_world(grid_pos)	
		
func player_in_front() -> bool:
	return player_character.grid_pos.y == grid_pos.y
	
#shoot funtion sets the postion of the projectile with marker2d
func shoot():
	var projectile = EnemyBasicProjectile.instantiate()

	projectile.global_position = ProjectileShootPoint.global_position
	projectile.direction = Vector2.LEFT

	projectile.damage = attack_power

	get_tree().current_scene.add_child(projectile)
