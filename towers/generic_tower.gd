extends Area2D

@export var damage: int
@export var cooldown: float
@export var projectileScene: PackedScene

@onready var timer = $Timer
@onready var progress_bar = $TextureProgressBar
@onready var projectile_spawn_point = $ProjectileSpawnPoint
@onready var animation_player = $AnimationPlayer

var targetEnemy: CharacterBody2D = null
var enemies = []

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
	timer.wait_time = cooldown

func _on_body_shape_entered(_body_rid, body, _body_shape_index, _local_shape_index):
	enemies.push_back(body)
	if timer.is_stopped() and animation_player.current_animation != "attack":
		attack()

func _on_body_shape_exited(_body_rid, body, _body_shape_index, _local_shape_index):
	if body in enemies:
		enemies.erase(body)
	
func _on_timer_timeout():
	if len(enemies) == 0:
		return
	else:
		attack()
	
func attack():
	# Iterate over enemies in range
	print("looking for target")
	for e in enemies:
		# find the first one which does not have a killing blow on the way
		if not e.is_in_group("deathBlownEnemies"):
			targetEnemy = e
			break
	# If there is no such enemy, just return and continue looking
	if targetEnemy == null:
		return
	print("Tower " + name + " shooting at "  + targetEnemy.name + " with " + str(targetEnemy.hitpoints) + " hp remaining ")
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
		projectile.position = projectile_spawn_point.global_position
		projectile.damage = damage
		get_tree().root.call_deferred("add_child", projectile)
		animation_player.play("RESET")
		# Clear target enemy
		targetEnemy = null
