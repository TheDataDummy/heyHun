extends Node2D
@onready var ui = $UI
@onready var placeable_area = $placeableArea
@export var coinScene: PackedScene
@onready var animation_player = $AnimationPlayer

var build_valid = false
var night_wave = false

var build_mode
var build_location
var build_type 

signal build_mode_exited(cost: int)
signal earnCoins(value: int)
signal waveCompleted
signal enemyMadeIt

func _unhandled_input(event):
	if event.is_action_released("ui_accept") and build_mode == true:
		verify_and_build()
		cancel_build_mode()
	elif event.is_action_released("ui_cancel") and build_mode == true:
		cancel_build_mode()

func _process(_delta):
	if build_mode:
		update_tower_preview()

func _on_world_tower_slection_mode_entered(tower_name):
	if not night_wave:
		build_mode = true
		build_type = tower_name
		ui.set_tower_preview(tower_name, get_global_mouse_position())

func start_wave(spawners: PackedScene):
	var spawnScene = spawners.instantiate()
	call_deferred("add_child", spawnScene)
	spawnScene.call_deferred("start_wave")
	spawnScene.connect("waveOver", Callable(self, "wave_completed"))
	
func _on_enemy_goal_body_entered(body):
	print("enemy made it")
	if body.is_in_group("enemies"):
		body.made_it_home()
		enemyMadeIt.emit()

func update_tower_preview():
	var mouse_position = get_global_mouse_position()
	var current_tile = placeable_area.local_to_map(mouse_position)
	var tile_position = placeable_area.map_to_local(current_tile)
	if placeable_area.get_cell_source_id(current_tile) == 0:
		ui.update_tower_preview(tile_position, "5dc75d")
		build_valid = true
		build_location = tile_position
	else:
		ui.update_tower_preview(tile_position, "fa005d8e")
		build_valid = false

func cancel_build_mode():
	build_mode = false
	build_valid = false
	build_type = null
	ui.get_node("TowerPreview").queue_free()
	build_mode_exited.emit(0)

func verify_and_build():
	if build_valid:
		var new_tower = load("res://towers/" + build_type + ".tscn").instantiate()
		new_tower.position = build_location
		new_tower.place()
		add_child(new_tower, false)
		placeable_area.set_cell(placeable_area.local_to_map(build_location))
		build_mode_exited.emit(Globals.towerCosts[build_type])

func spawn_coin(p):
	var coin = coinScene.instantiate()
	coin.position = p
	call_deferred("add_child", coin)

func earn_coins(value: int):
	earnCoins.emit(value)

func wave_completed():
	waveCompleted.emit()

func enter_night_mode():
	animation_player.play("dayToNight")
