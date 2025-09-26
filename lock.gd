extends Node2D

signal unlockAnimationFinished
@onready var animation_player = $sprite/AnimationPlayer

func play_unlock():
	z_index = 100
	animation_player.play("unlock")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "unlock":
		visible = false
		unlockAnimationFinished.emit()
