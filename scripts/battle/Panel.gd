extends Area2D

enum Territory {
	PLAYER,
	ENEMY
}

var grid_x : int
var grid_y : int
var territory : Territory #who owns what
var is_raised : bool
var is_damaged : bool
