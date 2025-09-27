extends Area2D

@export var cooldown: float
@export var towerCost: int
@export var statusDuration: float

@onready var timer = $Timer
@onready var progress_bar = $cooldownbar
@onready var animation_player = $AnimationPlayer

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
	attackAnimationAndProjectile()
		
func attackAnimationAndProjectile():
	animation_player.play("attack")
	timer.start()

func _on_cloud_area_body_entered(body):
	body.slow(0.5, statusDuration)


func kill():
	queue_free()
