extends CanvasLayer

@onready var v_slider = $Panel/VBoxContainer/VSlider

var game_active

signal closed_options

# Called when the node enters the scene tree for the first time.
func _ready():
	if GameState.volume_slider_value:
		v_slider.value = GameState.volume_slider_value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_v_slider_drag_ended(value_changed):
	if value_changed:
		AudioScene.updateVolume(v_slider.value)

func _on_button_button_up():
	if game_active:
		closed_options.emit()
	if GameState.previous_scene == "res://utils/main_menu.tscn":
		GameState.previous_scene = "res://utils/options_menu.tscn"
		GameState.volume_slider_value = v_slider.value
		get_tree().change_scene_to_file("res://utils/main_menu.tscn")

func open_options_from_pause_menu():
	game_active = true
	visible = true

func close_options():
	game_active = false
	visible = false
