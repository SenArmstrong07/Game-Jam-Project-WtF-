extends Resource
class_name ChipDeck

var deck: Array[Chip] = []

func _init() -> void:
	_initialize_deck()

func _initialize_deck() -> void:
	# Default deck - customize per unit as needed
	# Chip format: Chip.new(name, power, range, description, effectiveness_map)
	deck = [
		Chip.new(
			"DELETE",
			15,
			1,
			"Direct system crash attack",
			{"CommonBug": Unit.DamageType.SUPER_EFFECTIVE, "Virus": Unit.DamageType.INEFFECTIVE} #example ng effectiveness mapping (NEEDS NEW ENEMIES)
		#GANITO NA MAGLAGAY NG TYPE EFFECTIVENESS, WE MAP IT
		),
		Chip.new(
			"Glitch Wave",
			12,
			2,
			"Mid-range glitch blast",
			{"CommonBug": Unit.DamageType.INEFFECTIVE, "Virus": Unit.DamageType.SUPER_EFFECTIVE}
		),
		Chip.new(
			"Corruption",
			18,
			1,
			"Powerful data corruption strike",
			{"CommonBug": Unit.DamageType.SUPER_EFFECTIVE, "Virus": Unit.DamageType.SUPER_EFFECTIVE}
		),
		Chip.new(
			"Malware Injection",
			10,
			3,
			"Long-range malware attack",
			{"CommonBug": Unit.DamageType.NEUTRAL, "Virus": Unit.DamageType.SUPER_EFFECTIVE}
		),
		Chip.new(
			"Logic Bomb",
			14,
			2,
			"Logic error attack",
			{"CommonBug": Unit.DamageType.SUPER_EFFECTIVE, "Virus": Unit.DamageType.NEUTRAL}
		),
		Chip.new(
			"Overflow Burst",
			20,
			1,
			"High damage buffer overflow",
			{"CommonBug": Unit.DamageType.INEFFECTIVE, "Virus": Unit.DamageType.NEUTRAL}
		),
	]

func draw_hand(hand_size: int = 5) -> Array[Chip]:
	var hand: Array[Chip] = []
	var available_indices: Array[int] = []
	
	# Build available indices
	for i in range(deck.size()):
		available_indices.append(i)
	
	# Draw unique chips
	for i in range(mini(hand_size, deck.size())):
		if available_indices.is_empty():
			break
		var random_idx = randi() % available_indices.size()
		var deck_idx = available_indices[random_idx]
		hand.append(deck[deck_idx].duplicate())
		available_indices.remove_at(random_idx)
	
	return hand

func set_custom_deck(new_deck: Array[Chip]) -> void:
	deck = new_deck
