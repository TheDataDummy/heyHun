extends Node2D
@onready var play_area = $PlayArea
@onready var side_bar = $SideBar
@onready var hud = $HUD

@export var money: int
@export var health: int

var placementMode = false
var towerSelected = null

var wave = 1
var wave_in_progress = false

signal tower_slection_mode_entered(tower_name: String)

func _ready():
	hud.set_coin_value(money)
	hud.set_current_wave(wave)
	hud.update_hp(health)

func _on_side_bar_tower_selected(button):
	var tower_name = button.name
	if !placementMode:
		if money >= Globals.towerCosts[tower_name]:
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
	if not wave_in_progress:
		var current_wave = load("res://waves/wave" + str(wave) + ".tscn")
		play_area.start_wave(current_wave)
		wave_in_progress = true
		hud.set_current_wave(wave)
		wave += 1 
	else:
		print("Wave still in progress.")
		print(str(len(get_tree().get_nodes_in_group("enemies"))) + " enemies remaining.")
		for e in get_tree().get_nodes_in_group("enemies"):
			print("Enemy: " + e.name + " at: " + str(e.global_position))

func _on_play_area_wave_completed():
	wave_in_progress = false
	print("Wave " + str(wave - 1) + " completed!")

func _on_play_area_enemy_made_it():
	health -= 1
	hud.update_hp(health)
