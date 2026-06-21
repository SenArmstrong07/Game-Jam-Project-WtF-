extends Resource
class_name ChipDeck

var deck: Array[Chip] = []

func _init() -> void:
	_initialize_deck()
	
func _initialize_deck() -> void:
	deck = [
		Chip.new(
			"DELETE",
			45,
			999,
			"Direct system crash attack",
			Chip.AttackType.PROJECTILE,
			{}
		),

		Chip.new(
			"Patch",
			25,
			999,
			"Homing DoT",
			Chip.AttackType.HOMING,
			{
				"CommonBug": Unit.DamageType.SUPER_EFFECTIVE
			}
		),

		Chip.new(
			"Quarantine",
			10,
			999,
			"Stunning projectile",
			Chip.AttackType.STUN_PROJECTILE,
			{}
		)
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
