extends Node2D
class_name BattleBase

enum BattlePhase {
	PREPARATION,
	BATTLE,
	END
}

var current_phase: BattlePhase = BattlePhase.PREPARATION

var blocked_tiles: Array[Vector2i] = []
var occupied_tiles := {}

func is_tile_free(tile: Vector2i) -> bool:
	return not occupied_tiles.has(tile)
