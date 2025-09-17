extends Area2D

const SPEED = 100

var target: CharacterBody2D = null
var direction: Vector2
var damage: int

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target != null:
		direction = global_position.direction_to(target.global_position)
		global_position += direction * SPEED * delta
	
func _on_body_entered(body):
	if body == target:
		body.kill()
		queue_free()
