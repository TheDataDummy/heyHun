extends Node2D
@onready var money = $money
@onready var current_wave = $currentWave
@onready var current_hp = $currentHp

func set_coin_value(value):
	money.text = str(value)

func set_current_wave(wave):
	current_wave.text = str(wave)

func update_hp(value):
	current_hp.text = str(value)
