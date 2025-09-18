extends Area2D

@export var damage: int
@export var cooldown: int
@export var projectileScene: PackedScene

@onready var timer = $Timer
@onready var progress_bar = $TextureProgressBar
@onready var projectile_spawn_point = $ProjectileSpawnPoint

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
	if timer.is_stopped():
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
	# Select an enemy to attack
	var enemy: CharacterBody2D = null
	# Iterate over enemies in range
	for e in enemies:
		# find the first one which does not have a killing blow on the way
		if not e.is_in_group("deathBlownEnemies"):
			enemy = e
			break
		else:
			print("I would attack that enemy but he should be dead")
	# If there is no such enemy, just return and continue looking
	if enemy == null:
		return
	
	# If there is an enemy that isn't about to die, attack it
	timer.start()
	var projectile = projectileScene.instantiate()
	projectile.target = enemy
	projectile.position = projectile_spawn_point.global_position
	projectile.damage = damage
	get_tree().root.call_deferred("add_child", projectile)
	
	# Determine if we will be killing the enemy with this shot
	if projectile.damage >= enemy.hitpoints:
		enemy.add_to_group("deathBlownEnemies")
