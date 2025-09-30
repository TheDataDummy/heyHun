extends Control

func _on_button_button_up():
	visible=false
	get_tree().paused = false

func _on_restart_button_up():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://utils/main_menu.tscn")

func _on_quit_button_up():
	get_tree().quit()
