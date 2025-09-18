extends Node2D

signal spawnCoin(pos: Vector2)

func _ready():
	spawnCoin.connect(Callable(get_parent(), "spawn_coin"))

func start_wave():
	for node in get_children():
		node.start_wave()

func enemy_died(p):
	spawnCoin.emit(p)
