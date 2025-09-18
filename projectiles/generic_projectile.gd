extends Area2D

const SPEED = 100

var target: CharacterBody2D = null
var direction: Vector2
var damage: int
@onready var animation_player = $AnimationPlayer

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if target != null:
		direction = global_position.direction_to(target.get_node("hitpoint").global_position)
		if animation_player.current_animation != "explode":
			look_at(target.global_position)

		global_position += direction * SPEED * delta
	
func _on_body_entered(body):
	if body == target:
		animation_player.play("explode")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "explode":
		target.kill()
		queue_free()
