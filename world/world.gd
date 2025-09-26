extends Node2D
@onready var play_area = $PlayArea
@onready var interface = $interface
@onready var transitions_and_titles = $transitionsAndTitles

@export var money: int
@export var health: int
var maxHealth = 8

var placementMode = false
var towerSelected = null

var wave = 5
var wave_in_progress = false
var night_wave = false
var night_waves = [6, 12, 18, 24, 999]
var wave_into_playing = false

var unlockedTowers = ['milkJug']

signal tower_slection_mode_entered(tower_name: String)

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		play_area.enter_night_mode()

func _ready():
	update_unlocked_towers()
	interface.set_money(money)
	interface.update_health(health)

func update_unlocked_towers():
	interface.update_unlocked_towers(unlockedTowers)

func _on_side_bar_tower_selected(button):
	var tower_name = button.name
	if !placementMode:
		if money >= Globals.towerCosts[tower_name]:
			placementMode = true
			towerSelected = tower_name
			tower_slection_mode_entered.emit(tower_name)
		else:
			print("Not enough money you cheap fuck")
			interface.deselect_all_buttons()

func _on_play_area_build_mode_exited(value):
	money -= value
	interface.deselect_all_buttons()
	placementMode = false
	interface.set_money(money)

func _on_play_area_earn_coins(value):
	money += value
	interface.set_money(money)

func _on_button_button_up():
	if wave in night_waves and not wave_in_progress:
		night_wave = true
		play_area.night_wave = true
	if not wave_in_progress:
		transitions_and_titles.play_wave_intro(wave)
		wave_into_playing = true
	else:
		print("Wave still in progress.")
		print(str(len(get_tree().get_nodes_in_group("enemies"))) + " enemies remaining.")
		for e in get_tree().get_nodes_in_group("enemies"):
			print("Enemy: " + e.name + " at: " + str(e.global_position))

func _on_play_area_wave_completed():
	if night_wave == true:
		night_wave = false
		play_area.night_wave = false
	wave_in_progress = false
	print("Wave " + str(wave - 1) + " completed!")

func _on_play_area_enemy_made_it():
	health -= 1
	interface.update_health(health)

func _on_transitions_and_titles_wave_intro_over():
	wave_into_playing = false
	var current_wave = load("res://waves/wave" + str(wave) + ".tscn")
	play_area.start_wave(current_wave)
	wave_in_progress = true
	wave += 1 
