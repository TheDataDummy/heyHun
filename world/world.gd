extends Node2D
@onready var play_area = $PlayArea
@onready var interface = $interface
@onready var transitions_and_titles = $transitionsAndTitles
@onready var pause_menu = $pause_menu
@onready var death_menu = $death_menu

@export var money: int
@export var health: int
@export var wave = 1

var maxHealth = 8

var placementMode = false
var towerSelected = null

var night_waves = [6, 12, 18, 24, 999]

var unlocks = {
	1: "milkJug",
	7: "diffuser",
	13: "pillDispenser"
}

# State
var wave_intro_playing = false
var wave_in_progress = false
var night_wave = false
var wave_passed_playing = false

var unlockedTowers = []

signal tower_slection_mode_entered(tower_name: String)

func _unhandled_input(event):
	if event.is_action_pressed("ui_right"):
		play_area.enter_night_mode()

func _ready():
	for i in unlocks:
		if i <= wave:
			unlockedTowers.append(unlocks[i])
			update_unlocked_towers(unlocks[i])
	interface.set_money(money)
	interface.update_health(health)
	interface.update_wave_display(wave)

func update_unlocked_towers(tower):
	unlockedTowers.append(tower)
	interface.update_unlocked_towers(unlockedTowers[-1])

func _on_side_bar_tower_selected(button):
	var tower_name = button.name
	if !placementMode:
		if money >= Globals.towerCosts[tower_name]:
			placementMode = true
			towerSelected = tower_name
			tower_slection_mode_entered.emit(tower_name)
			play_area.tower_info_box_exited()
		else:
			print("Not enough money you cheap fuck")
			interface.deselect_all_buttons()

func update_money(newValue):
	money = newValue
	interface.set_money(money)

func _on_play_area_build_mode_exited(value):
	update_money(money - value)
	interface.deselect_all_buttons()
	placementMode = false

func _on_play_area_earn_coins(value):
	update_money(money + value)

func _on_button_button_up():
	if wave in night_waves and not wave_in_progress:
		night_wave = true
		play_area.enter_night_mode()
		print("Playing bill's music")
		AudioScene.play_music_bill()
	if not wave_in_progress and not wave_passed_playing:
		transitions_and_titles.play_wave_intro(wave)
		wave_intro_playing = true
		interface.update_wave_display(wave)
	elif len(get_tree().get_nodes_in_group("enemies")) > 0:
		print("Wave still in progress.")
		print(str(len(get_tree().get_nodes_in_group("enemies"))) + " enemies remaining.")
		for e in get_tree().get_nodes_in_group("enemies"):
			print("Enemy: " + e.name + " at: " + str(e.global_position))
	else:
		print("IDK why but you can't play")

func _on_play_area_wave_completed():
	if night_wave == true:
		night_wave = false
		play_area.exit_night_mode()
	wave_in_progress = false
	print("Wave " + str(wave - 1) + " completed!")
	transitions_and_titles.play_wave_completed()
	wave_passed_playing = true
	if wave + 1 in night_waves:
		AudioScene.fade_out()
	elif wave - 1 in night_waves:
		AudioScene.fade_out()
		AudioScene.queue_theme()

func _on_play_area_enemy_made_it():
	health -= 1
	interface.update_health(health)
	if health <= 0:
		get_tree().paused = true
		death_menu.visible = true

func _on_transitions_and_titles_wave_intro_over():
	wave_intro_playing = false
	var current_wave = load("res://waves/wave" + str(wave) + ".tscn")
	play_area.start_wave(current_wave)
	wave_in_progress = true
	wave += 1 

func _on_transitions_and_titles_wave_passed_over():
	wave_passed_playing = false
	if wave in unlocks:
		update_unlocked_towers(unlocks[wave])

func _on_play_area_tower_info_box_entered():
	pass # Replace with function body.

func _on_play_area_tower_info_box_exited():
	pass # Replace with function body.

func _on_play_area_issue_refund(value):
	update_money(money + value)

func _on_play_area_charge_for_upgrade(cost):
	if money - cost < 0:
		play_area.upgrade_denied()
	else:
		play_area.upgrade_approved()
		update_money(money - cost)

func _on_pause_button_up():
	pause_menu.visible = true
	get_tree().paused=true
