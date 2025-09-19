extends Node2D
@onready var money = $money

func set_coin_value(value):
	money.text = str(value)
