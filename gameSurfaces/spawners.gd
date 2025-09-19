extends Node2D

@onready var timer = $Timer

signal spawnCoin(pos: Vector2)
signal earnCoins(coins: int)
signal waveOver(name: String)

func _ready():
	spawnCoin.connect(Callable(get_parent(), "spawn_coin"))
	earnCoins.connect(Callable(get_parent(), "earn_coins"))

func start_wave():
	for node in get_children():
		if not node is Timer:
			node.start_wave()

func enemy_died(p):
	spawnCoin.emit(p)
	if len(get_tree().get_nodes_in_group("enemies")) == 1:
		timer.start()

func dropCoins(value):
	earnCoins.emit(value)

func _on_timer_timeout():
	if len(get_tree().get_nodes_in_group("enemies")) == 0:
		waveOver.emit(self.name)
		queue_free()
