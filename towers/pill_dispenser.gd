extends Area2D

@export var damage: int
@export var cooldown: float
@export var projectileScene: PackedScene
@export var towerCost: int
@export var splash_range: int

@onready var timer = $Timer
@onready var progress_bar = $cooldownbar
@onready var projectile_spawn_point = $ProjectileSpawnPoint
@onready var animation_player = $AnimationPlayer

var projectile

var targetEnemy: CharacterBody2D = null
var enemies = []
var attack_mode = false
var placed = false

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

func attack():
	targetEnemy = null
	# Iterate over enemies in range
	for e in enemies:
		# find the first one which does not have a killing blow on the way
		if not e.is_in_group("deathBlownEnemies"):
			targetEnemy = e
			break
	# If there is no such enemy, just return and continue looking
	if targetEnemy == null:
		return
	
	# Determine if we will be killing the enemy with this shot
	if damage >= targetEnemy.queuedHitpoints:
		targetEnemy.add_to_group("deathBlownEnemies")
	
	# queue damage on splash enemies
	var splash_enemies = get_non_death_blown_enemies_in_splash_range(targetEnemy)
	targetEnemy.queue_damage(damage)
	
	for splash_enemy in splash_enemies:
		if damage >= splash_enemy.queuedHitpoints:
			splash_enemy.add_to_group("deathBlownEnemies")
		splash_enemy.queue_damage(damage)
	
	attackAnimationAndProjectile(splash_enemies)
	

func get_non_death_blown_enemies_in_splash_range(targ):
	var enemies_in_splash_range = []
	# Iterate over all enemies currently in the tower's range
	for enemy in get_tree().get_nodes_in_group("enemies"):
		# Exclude the target enemy itself from the splash damage check
		if enemy == targ or enemy.is_in_group("deathBlownEnemies"):
			continue

		# Calculate the distance between the enemy and the target
		var distance = enemy.global_position.distance_to(targ.global_position)
		
		# Check if the enemy is within the splash damage radius
		if distance <= splash_range:
			enemies_in_splash_range.append(enemy)
	
	return enemies_in_splash_range



func attackAnimationAndProjectile(splash_enemies):
	animation_player.play("attack")
	# instantiate projectile and set initial variables
	projectile = projectileScene.instantiate()
	projectile.target = targetEnemy
	projectile.position = projectile_spawn_point.global_position
	projectile.damage = damage
	projectile.splash_enemies = splash_enemies
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "attack":
		# Start the cooldown
		timer.start()
		# Spawn projectile
		get_tree().root.call_deferred("add_child", projectile)
		animation_player.play("cooldown")
		# Clear target enemy
		targetEnemy = null


func kill():
	queue_free()
