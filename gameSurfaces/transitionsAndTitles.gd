extends CanvasLayer
@onready var number = $waveTitle/number
var textures = {}
@onready var animation_player = $AnimationPlayer

signal wave_intro_over
signal wave_passed_over

func _ready():
	for i in range(1,7):
		textures[i] = load("res://artAssets/uiElements/acidText/number" + str(i) + ".png")

func play_wave_intro(wave_number):
	number.texture = textures[wave_number]
	animation_player.play("waveIntro")

func play_wave_completed():
	animation_player.play("wavePassed")

func _on_animation_player_animation_finished(anim_name):
	if anim_name == "waveIntro":
		wave_intro_over.emit()
	elif anim_name == 'wavePassed':
		wave_passed_over.emit()
