extends Node2D
@onready var ui = $UI
@onready var placeable_area = $placeableArea
@export var coinScene: PackedScene
@onready var animation_player = $AnimationPlayer
@onready var sub_viewport = $SubViewport

var build_valid = false
var night_wave = false

var build_mode
var build_location
var build_type 
var info_box_tower

var screenshot = false

signal build_mode_exited(cost: int)
signal earnCoins(value: int)
signal waveCompleted
signal enemyMadeIt
signal towerInfoBoxEntered
signal towerInfoBoxExited
signal issue_refund(value: int)
signal charge_for_upgrade(cost: int)

func _ready():
	if screenshot:
		# Example usage:
		# Replace "res://exported_tilemap.png" with your desired save path
		var error = await save_tilemap_as_png("res://exported_tilemap.png")
		if error != OK:
			print("Error saving PNG: ", error)
		else:
			print("TileMap successfully exported to PNG!")

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
		add_child(new_tower, false)
		new_tower.place()
		new_tower.connect("towerInfoBoxEntered", Callable(self, "tower_info_box_entered").bind(new_tower))
		new_tower.connect("towerInfoBoxExited", Callable(self, "tower_info_box_exited"))
		new_tower.connect("issueRefund", Callable(self, "refund_tower"))
		new_tower.connect("towerUpgraded", Callable(self, "upgrade_tower"))
		new_tower.connect("towerDestroyed", Callable(self, "reclaim_land").bind(new_tower))
		var map_coords = placeable_area.local_to_map(build_location)
		new_tower.map_coords = map_coords
		new_tower.saved_source_id = placeable_area.get_cell_source_id(map_coords)
		new_tower.saved_atlas_coords = placeable_area.get_cell_atlas_coords(map_coords)

		new_tower.towerNameLookup = build_type
		placeable_area.set_cell(map_coords)
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
	night_wave = true

func exit_night_mode():
	animation_player.play("nightToDay")
	night_wave = false

func reclaim_land(tower):
	placeable_area.set_cell(tower.map_coords, tower.saved_source_id, tower.saved_atlas_coords)

func tower_info_box_entered(tower):
	print(info_box_tower)
	if info_box_tower:
		if tower == info_box_tower:
			tower_info_box_exited()
		return
	
	if not night_wave and not build_mode:
		tower.show_info_box()
		towerInfoBoxEntered.emit()
		info_box_tower = tower
	

func tower_info_box_exited():
	if not is_instance_valid(info_box_tower):
		towerInfoBoxExited.emit()
		info_box_tower = null
		return
	if info_box_tower:
		info_box_tower.hide_info_box()
		towerInfoBoxExited.emit()
		info_box_tower = null

func refund_tower(value):
	issue_refund.emit(value)

func upgrade_tower(cost):
	charge_for_upgrade.emit(cost)

func upgrade_denied():
	pass

func upgrade_approved():
	info_box_tower.upgrade_approved()

func save_tilemap_as_png(file_path: String) -> Error:
	# Ensure the viewport has rendered at least one frame
	await RenderingServer.frame_post_draw
	# Get the viewport's texture
	var viewport_texture = sub_viewport.get_texture()
	# Get the Image data from the texture
	var image: Image = viewport_texture.get_image()
	# Save the Image as a PNG file
	return image.save_png(file_path)
