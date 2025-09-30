extends Node2D

func _on_start_button_up():
	get_tree().change_scene_to_file("res://world/world.tscn")

func _on_options_button_up():
	print(":)")

func _on_quit_button_up():
	get_tree().quit()
