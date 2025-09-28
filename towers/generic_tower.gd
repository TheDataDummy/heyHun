extends Area2D

@export var damage: int
@export var cooldown: float
@export var projectileScene: PackedScene
@export var towerCost: int
@export var upgradeValue: float

@onready var timer = $Timer
@onready var progress_bar = $cooldownbar
@onready var projectile_spawn_point = $ProjectileSpawnPoint
@onready var animation_player = $AnimationPlayer
@onready var info_box = $infoBox
@onready var tower = $tower

var towerNameLookup
var targetEnemy: CharacterBody2D = null
var enemies = []
var attack_mode = false
var placed = false
var upgraded = false
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
		
	if timer.is_stopped() and animation_player.current_animation != "attack" and attack_mode:
		attack()

func _ready():
	timer.wait_time = cooldown

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	enemies.push_back(body)

func _on_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body in enemies:
		enemies.erase(body)
	
func _on_timer_timeout():
	if len(enemies) == 0:
		return

func place():
	attack_mode = true
	placed = true

func attack():
	# Iterate over enemies in range
	for e in enemies:
		# find the first one which does not have a killing blow on the way
		if not e.is_in_group("deathBlownEnemies"):
			targetEnemy = e
			break
	# If there is no such enemy, just return and continue looking
	if targetEnemy == null:
		return
	#print("Tower " + name + " shooting at "  + targetEnemy.name + " with " + str(targetEnemy.hitpoints) + " hp remaining ")
	# Determine if we will be killing the enemy with this shot
	if damage >= targetEnemy.queuedHitpoints:
		targetEnemy.add_to_group("deathBlownEnemies")
		
	targetEnemy.queue_damage(damage)
	
	attackAnimationAndProjectile()

func attackAnimationAndProjectile():
	animation_player.play("attack")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		# Start the cooldown
		timer.start()
		# Spawn projectile
		var projectile = projectileScene.instantiate()
		projectile.target = targetEnemy
		projectile.damage = damage
		call_deferred("add_child", projectile)
		projectile.call_deferred("set_global_position", projectile_spawn_point.global_position)
		projectile.call_deferred("set_z_index", 200)
		animation_player.play("RESET")
		# Clear target enemy
		targetEnemy = null

func _on_clickbox_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and placed:
		if event.pressed:
			# emit the tower info box click signal because we need to see if we can enter before showing
			towerInfoBoxEntered.emit()

func show_info_box():
	info_box.get_node("sellValue").text = '[center]' + str(Globals.towerRefundValue[towerNameLookup])
	if not upgraded:
		info_box.get_node("upgradeCost").text = '[center]' + str(Globals.upgradeCosts[towerNameLookup])
	else:
		info_box.get_node("upgradeCost").text = '[center]XX'
	info_box.visible = true

func hide_info_box():
	info_box.visible = false

func _on_texture_button_button_up():
	towerInfoBoxExited.emit()

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
	cooldown = upgradeValue
	timer.wait_time = cooldown
	towerInfoBoxExited.emit()
	upgraded = true
	tower.modulate = Color("90EE90")
	info_box.get_node("upgrade").visible = false
