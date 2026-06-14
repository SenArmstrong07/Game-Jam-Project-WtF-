extends Node2D
class_name Unit

#Superclass ito, in which magiinherit sila PLAYER and ENEMY

enum Team {
	PLAYER,
	ENEMY
}

var team : Team

var grid_x : int
var grid_y : int

var hp : int = 100

func take_damage(amount:int):
	hp -= amount
	if hp <= 0:
		die()
	
func restore_hp(amount:int):
	hp += amount

func die():
	queue_free()
