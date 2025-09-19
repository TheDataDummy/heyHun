extends Node2D
@onready var play_area = $PlayArea
@onready var side_bar = $SideBar
@onready var hud = $HUD

@export var money: int
@export var health: int
@export var wave1: PackedScene

var placementMode = false
var towerSelected = null

signal tower_slection_mode_entered(tower_name: String)

var towerCosts = {
	"milkJug" : 3
}

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_side_bar_tower_selected(button):
	var tower_name = button.name
	if !placementMode:
		if money >= towerCosts[tower_name]:
			placementMode = true
			towerSelected = tower_name
			tower_slection_mode_entered.emit(tower_name)
		else:
			print("Not enough money you cheap fuck")
			side_bar.deselect_all_buttons()

func _on_play_area_build_mode_exited(value):
	money -= value
	hud.set_coin_value(money)
	side_bar.deselect_all_buttons()
	placementMode = false

func _on_play_area_earn_coins(value):
	money += value
	hud.set_coin_value(money)

func _on_button_button_up():
	play_area.start_wave(wave1)
