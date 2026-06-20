extends Node2D
class_name Battlescene

enum BattlePhase {
	PREPARATION,
	BATTLE,
	END
}

var current_phase: BattlePhase = BattlePhase.PREPARATION

@onready var grid = $Grid
@onready var player: Unit = $PlayerCharacter
@onready var enemy: Unit = $CommonBug

# PLAYER ONLY uses chips now
var player_deck: ChipDeck
var player_hand: Array[Chip] = []

var player_selected_chip: Chip = null
var player_chip_index: int = 0

var battle_active: bool = false

signal phase_changed(new_phase: BattlePhase)
signal player_chip_selected(chip: Chip)
signal battle_ended(winner: Unit)

func _ready() -> void:
	player_deck = ChipDeck.new()

	player.unit_died.connect(_on_unit_died)
	enemy.unit_died.connect(_on_unit_died)

	_start_preparation_phase()

func _process(delta: float) -> void:
	match current_phase:
		BattlePhase.PREPARATION:
			_handle_preparation_input()
		BattlePhase.BATTLE:
			if battle_active:
				_handle_battle_input()

# ============================================================
# PREPARATION PHASE
# ============================================================

func _start_preparation_phase() -> void:
	print("=== PREPARATION PHASE ===")

	current_phase = BattlePhase.PREPARATION
	phase_changed.emit(current_phase)

	player_hand = player_deck.draw_hand(5)

	player_chip_index = 0
	player_selected_chip = null

	var chip_names := []

	for chip in player_hand:
		chip_names.append(chip.name)

	print("Player hand: ", chip_names)

func _handle_preparation_input() -> void:
	if player_hand.is_empty():
		return

	# Browse chips
	if Input.is_action_just_pressed("ui_right"):
		player_chip_index = (player_chip_index + 1) % player_hand.size()
		print("Viewing: ", player_hand[player_chip_index].name)

	if Input.is_action_just_pressed("ui_left"):
		player_chip_index = (player_chip_index - 1 + player_hand.size()) % player_hand.size()
		print("Viewing: ", player_hand[player_chip_index].name)

	# Select chip
	if Input.is_action_just_pressed("ui_accept"):
		player_selected_chip = player_hand[player_chip_index]

		print("Selected chip: ", player_selected_chip.name)

		player_chip_selected.emit(player_selected_chip)

		_start_battle_phase()

# ============================================================
# BATTLE PHASE
# ============================================================

func _start_battle_phase() -> void:
	print("=== BATTLE PHASE ===")

	current_phase = BattlePhase.BATTLE
	phase_changed.emit(current_phase)

	battle_active = true

	# Apply selected chip stats
	player.attack_range = player_selected_chip.range_tile
	player.attack_power = player_selected_chip.power

	print("Battle started!")
	print("Player chip: ", player_selected_chip.name)

	# Enemy AI now handles: (found in the enemy script)
	# - movement
	# - targeting
	# - shooting projectiles

func _handle_battle_input() -> void:
	if player_selected_chip == null:
		return

	# Use selected chip
	if Input.is_action_just_pressed("ui_accept"):

		if player.attack_with_chip(enemy, player_selected_chip):

			print("Player used ", player_selected_chip.name)

			await get_tree().create_timer(1.0).timeout

			if is_instance_valid(enemy):
				_next_round()

# ============================================================
# ROUND MANAGEMENT
# ============================================================

func _next_round() -> void:
	if current_phase == BattlePhase.END:
		return

	player_selected_chip = null

	_start_preparation_phase()

# ============================================================
# DEATH / END BATTLE
# ============================================================

func _on_unit_died(unit: Unit) -> void:
	if current_phase == BattlePhase.END:
		return

	battle_active = false
	current_phase = BattlePhase.END

	print(unit.name, " died!")

	# stop the game
	for child in get_children():
		if child.has_method("set_process"):
			child.set_process(false)
		if child.has_method("set_physics_process"):
			child.set_physics_process(false)

	# restart on player death
	if unit == player:
		await get_tree().create_timer(1.0).timeout
		get_tree().reload_current_scene()
		return

	var winner = enemy
	print("Winner: ", winner.name)
	battle_ended.emit(winner)
