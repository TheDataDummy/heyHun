extends CanvasLayer

func _on_new_game_button_up():
	get_tree().paused = false
	GameState.previous_scene = "res://utils/win_menuu.tscn"
	get_tree().change_scene_to_file("res://utils/main_menu.tscn")

func _on_quit_button_up():
	get_tree().quit()
