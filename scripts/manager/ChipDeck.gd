extends Resource
class_name ChipDeck

var deck: Array[Chip] = []

func _init() -> void:
	_initialize_deck()

func _initialize_deck() -> void:
	# Default deck - customize per unit as needed
	#COMP: Name, dmg_type, power, range, desc (about sa damage type, irerevamp ko pa  usage here)
	deck = [
		Chip.new("Crash Strike", Unit.DamageType.NEUTRAL, 15, 1, "Direct crash attack"),
		Chip.new("Glitch Wave", Unit.DamageType.INEFFECTIVE, 12, 2, "Mid-range glitch blast"),
		Chip.new("Corruption", Unit.DamageType.SUPER_EFFECTIVE, 18, 1, "Powerful corrupt strike"),
		Chip.new("Malware Injection", Unit.DamageType.SUPER_EFFECTIVE, 10, 3, "Long-range malware"),
		Chip.new("Logic Bomb", Unit.DamageType.NEUTRAL, 14, 2, "Logic error attack"),
		Chip.new("Overflow Burst", Unit.DamageType.NEUTRAL, 20, 1, "High damage overflow"),
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
