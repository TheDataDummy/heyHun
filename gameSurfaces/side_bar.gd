extends Node2D

@onready var label = $moneyDisplay/money/label
@onready var towers = $towerUI/UI/towers

var unlocked_towers = []
var selection_mode = true
signal tower_selected(tower_name: String)

func _ready():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.connect("pressed", Callable(self, "initiate_build_mode").bind(button))
	for button in get_tree().get_nodes_in_group("infoButtons"):
		button.connect("pressed", Callable(self, "showInfo").bind(button))
	
	var towerLock = towers.get_node("lock1")
	towerLock.visible = false

func update_unlocked_towers(tower_array):
	unlocked_towers = tower_array
	if len(unlocked_towers) > 1:
		for i in range(len(unlocked_towers)):
			var towerLock = towers.get_node("lock" + str(i + 1))
			towerLock.play_unlock()
			selection_mode = false

func initiate_build_mode(button):
	if button.name in unlocked_towers and selection_mode:
		tower_selected.emit(button)
	else:
		deselect_all_buttons()

func deselect_all_buttons():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.button_pressed = false

func set_money(value):
	label.text = str(value)

func _on_lock_unlock_animation_finished():
	selection_mode = true

func showInfo(button):
	print(button.name)
