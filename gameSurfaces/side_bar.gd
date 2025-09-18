extends Node2D

signal tower_selected(tower_name: String)

func _ready():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.connect("pressed", Callable(self, "initiate_build_mode").bind(button.name))

func initiate_build_mode(buttonName):
	print("Let's build!", buttonName)
	tower_selected.emit(buttonName)
