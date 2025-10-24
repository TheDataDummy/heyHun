extends Node2D
@onready var play_area = $PlayArea
@onready var interface = $interface
@onready var transitions_and_titles = $transitionsAndTitles
@onready var pause_menu = $pause_menu
@onready var death_menu = $death_menu
@onready var win_menu = $win_menu

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
	13: "pillDispenser",
	19: "sprinkler"
}

# State
var wave_intro_playing = false
var wave_in_progress = false
var night_wave = false
var wave_passed_playing = false

var unlockedTowers = []
var invincibility = false

signal tower_slection_mode_entered(tower_name: String)

func _process(delta):
	# Example: Speed up the game by 4x when the space bar is pressed
	if Input.is_action_just_pressed("ui_down"): # "ui_accept" is often mapped to spacebar
		Engine.time_scale = 10.0
	if Input.is_action_just_released("ui_down"):
		Engine.time_scale = 1.0
	if Input.is_action_just_pressed("ui_up"):
		play_area.kill_all_enemies()
	if Input.is_action_just_pressed("ui_right"):
		invincibility = true

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
		AudioScene.start_bill_delay_timer()
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
		if wave_in_progress:
			print("wave still in progress for some reason")
			wave_in_progress = false
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
	if wave in night_waves or wave - 1 in night_waves:
		if wave - 1 == 24:
			AudioScene.fade_out(1)
			get_tree().paused = true
			win_menu.visible = true
		else:
			AudioScene.fade_out()

func _on_play_area_enemy_made_it():
	if invincibility:
		return
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
		health += 1
		interface.update_health(health)

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

func _on_play_area_game_over():
	if invincibility:
		return
	health = 0
	interface.update_health(health)
	if health <= 0:
		get_tree().paused = true
		death_menu.visible = true
