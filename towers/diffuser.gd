extends Area2D

@export var cooldown: float
@export var towerCost: int
@export var statusDuration: float
@export var upgradeValue: int

@onready var timer = $Timer
@onready var progress_bar = $cooldownbar
@onready var animation_player = $AnimationPlayer
@onready var cloud_area = $cloudArea
@onready var info_box = $infoBox
@onready var tower = $tower
@onready var clickbox = $clickbox
@onready var target_range = $targetRange

var targetEnemy: CharacterBody2D = null
var enemies = []
var attack_mode = false
var placed = false
var upgraded = false
var towerNameLookup
var saved_source_id 
var saved_atlas_coords 
var map_coords

signal towerInfoBoxEntered
signal towerInfoBoxExited
signal issueRefund(value: int)
signal towerUpgraded(cost: int)
signal towerDestroyed

func _process(_delta):
	# Calculate the remaining time percentage
	var time_left = timer.time_left
	var total_time = timer.wait_time
	
	# Ensure no division by zero if total_time is somehow 0
	if total_time > 0:
		# Progress bar value is a percentage from 0 to 1
		# Subtract from 1 for a countdown effect (e.g., 100% to 0%)
		var progress_percentage = 1.0 - (time_left / total_time)
		progress_bar.value = progress_percentage

func _ready():
	cloud_area.monitoring = false
	cloud_area.monitorable = false
	timer.wait_time = cooldown

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	enemies.push_back(body)
	if timer.is_stopped() and animation_player.current_animation != "attack" and attack_mode:
		attack()

func _on_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body in enemies:
		enemies.erase(body)
	
func _on_timer_timeout():
	if len(enemies) == 0:
		return
	elif attack_mode:
		attack()

func place():
	attack_mode = true
	placed = true
	cloud_area.monitoring = true
	cloud_area.monitorable = true

func attack():
	attackAnimationAndProjectile()
		
func attackAnimationAndProjectile():
	animation_player.call_deferred("play", "attack")
	timer.start()

func _on_cloud_area_body_entered(body):
	body.slow(0.5, statusDuration)

func _on_clickbox_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and placed:
		if event.pressed:
			# emit the tower info box click signal because we need to see if we can enter before showing
			towerInfoBoxEntered.emit()

func _on_texture_button_button_up():
	towerInfoBoxExited.emit()

func show_info_box():
	info_box.get_node("sellValue").text = '[center]' + str(Globals.towerRefundValue[towerNameLookup])
	if not upgraded:
		info_box.get_node("upgradeCost").text = '[center]' + str(Globals.upgradeCosts[towerNameLookup])
	else:
		info_box.get_node("upgradeCost").text = '[center]XX'
	info_box.visible = true

func hide_info_box():
	info_box.visible = false

func _on_sell_button_up():
	refund()

func _on_upgrade_button_up():
	upgrade()

func kill():
	towerDestroyed.emit()
	queue_free()

func upgrade():
	if not upgraded:
		towerUpgraded.emit(Globals.upgradeCosts[towerNameLookup])

func refund():
	issueRefund.emit(Globals.towerRefundValue[towerNameLookup])
	kill()

func upgrade_approved():
	statusDuration = upgradeValue
	towerInfoBoxExited.emit()
	upgraded = true
	tower.modulate = Color("90EE90")
	info_box.get_node("upgrade").visible = false
