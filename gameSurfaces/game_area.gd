extends Node2D

func _on_enemy_goal_body_entered(body):
	print("enemy made it")
	if body.is_in_group("enemies"):
		body.made_it_home()
