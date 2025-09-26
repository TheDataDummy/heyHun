extends Node2D

@onready var label = $moneyDisplay/money/label
@onready var towers = $towerUI/UI/towers
@onready var info_box = $infoBox
@onready var enemies = $towerUI/UI/enemies
@onready var hp = $hpDisplay/hp

var unlocked_towers = []
var selection_mode = true
var info_mode
var info_target

signal tower_selected(tower_name: String)

func _ready():
	for button in get_tree().get_nodes_in_group("towerButtons"):
		button.connect("pressed", Callable(self, "initiate_build_mode").bind(button))
	for button in get_tree().get_nodes_in_group("infoButtons"):
		button.connect("pressed", Callable(self, "_on_info_toggled").bind(button))
		
	#var towerLock = towers.get_node("lock1")
	#towerLock.visible = false

func update_unlocked_towers(tower_array):
	unlocked_towers = tower_array
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

func update_health(health):
	hp.value = health

func _on_lock_unlock_animation_finished():
	selection_mode = true

func _on_info_exit_button_up():
	exit_info_mode()

func exit_info_mode():
	untoggle_all_info_buttons()
	info_mode = false
	info_target = null
	info_box.hide_info()

func enter_info_mode(enemy):
	info_mode = true
	info_target = enemy
	info_box.show_info(enemy)

func _on_info_toggled(button):
	var toggled_on = button.button_pressed
	if toggled_on:
		enter_info_mode(button.name.split("_")[0])
		print(info_target)
	else:
		exit_info_mode()

func untoggle_all_info_buttons():
	for button in get_tree().get_nodes_in_group("infoButtons"):
		button.button_pressed = false
