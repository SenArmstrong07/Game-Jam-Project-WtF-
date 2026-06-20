extends CharacterBody2D 

#temporary overworld enemy object lang toh

signal died

var speed = 60
var player_chase : bool = false
var player = null

func _physics_process(delta: float) -> void:
	if player_chase:
		position += (player.position - position) / speed
		
		$sprite.play("s_walk")
		if (player.position.x - position.x) < 0:
			$sprite.flip_h = false
		else:
			$sprite.flip_h = true
	else:
		$sprite.stop()


func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true


func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false


func _on_battle_trigger_body_entered(body: Node2D) -> void:
	# Check if the body is the player
	if body == player:
		trigger_battle() # (COLLISION) NOTE TO SELF: DAPAT PAREHAS YUNG LAYER AND MASK INDEX WITH THE LAYER AND MASK INDEX NG PLAYER TO TRIGGER A BATTLE SEQUENCE


func trigger_battle() -> void:
	print("TRANSITION TO BATTLE")
	# TODO: Implement actual battle scene transition here
