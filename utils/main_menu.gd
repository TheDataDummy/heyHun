extends Node2D
@onready var animation_player = $AnimationPlayer

func _ready():
	AudioScene.play_music_title()
	if not GameState.previous_scene:
		animation_player.play("introduction")
	else:
		animation_player.play("default")

func _on_options_button_up():
	GameState.previous_scene = "res://utils/main_menu.tscn"
	get_tree().change_scene_to_file("res://utils/options_menu.tscn")

func _on_quit_button_up():
	get_tree().quit()

func _on_new_game_button_up():
	get_tree().change_scene_to_file("res://world/world.tscn")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "introduction":
		animation_player.play("default")
