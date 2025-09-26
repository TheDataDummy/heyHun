extends Node2D

signal tower_selected(tower_name: String)
@onready var label = $moneyDisplay/money/label

func _ready():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.connect("pressed", Callable(self, "initiate_build_mode").bind(button))

func initiate_build_mode(button):
	tower_selected.emit(button)

func deselect_all_buttons():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.button_pressed = false

func set_money(value):
	label.text = str(value)
