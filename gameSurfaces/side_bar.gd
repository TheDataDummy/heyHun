extends Node2D

signal tower_selected(tower_name: String)

func _ready():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.connect("pressed", Callable(self, "initiate_build_mode").bind(button))

func initiate_build_mode(button):
	tower_selected.emit(button)

func deselect_all_buttons():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.button_pressed = false
