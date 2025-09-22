# Projectile.gd
extends Area2D

@export var peak_height: float = 150.0 # Adjust this value in the inspector to control the arc height

const FLIGHT_TIME = 1 # Time it takes to reach the target (in seconds)

var splash_enemies
var target: CharacterBody2D = null
var damage: int
@onready var animation_player = $AnimationPlayer

var start_position: Vector2
var control_point: Vector2
var time_elapsed: float = 0.0
var current_target_position

func _ready():
	start_position = global_position
	# Define the control point for the Bézier curve.
	# This point is above the midpoint between the start and target positions.
	if is_instance_valid(target):
		var midpoint = (start_position + target.global_position) / 2
		control_point = midpoint + Vector2(0, -peak_height)

func _physics_process(delta):
	time_elapsed += delta
	var t = min(time_elapsed / FLIGHT_TIME, 1.0)
	
	# Get the current position of the moving target.
	if is_instance_valid(target):
		current_target_position = target.global_position
	
	# Calculate the position along the quadratic Bézier curve.
	# The formula is: P(t) = (1-t)^2 * P0 + 2(1-t)t * P1 + t^2 * P2
	# P0 = start_position, P1 = control_point, P2 = current_target_position
	var new_position = (1 - t) * (1 - t) * start_position + 2 * (1 - t) * t * control_point + t * t * current_target_position
	
	global_position = new_position
	
	# Once the projectile has reached the end of its flight, trigger the hit logic.
	if t >= 1.0:
		_on_target_reached()

func _on_target_reached():
	# Use this function to handle the final actions instead of `_on_body_entered`.
	# This ensures the hit happens exactly when the animation starts, not on a physics collision.
	animation_player.play("explode")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		if is_instance_valid(target):
			# Use is_instance_valid to make sure the target still exists before calling hit()
			target.hit(damage)
		for enemy in splash_enemies:
			if is_instance_valid(enemy):
			# Use is_instance_valid to make sure the target still exists before calling hit()
				enemy.hit(damage)
		queue_free()
