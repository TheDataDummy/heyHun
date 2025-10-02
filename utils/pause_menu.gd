extends CanvasLayer
@onready var options_menu = $options_menu
@onready var panel = $Panel

func _on_button_button_up():
	visible=false
	get_tree().paused = false
	
func _on_quit_button_up():
	get_tree().quit()

func _on_options_button_up():
	GameState.previous_scene = "res://utils/pause_menu.tscn"
	options_menu.open_options_from_pause_menu()
	panel.visible = false

func _on_options_menu_closed_options():
	options_menu.close_options()
	panel.visible = true
