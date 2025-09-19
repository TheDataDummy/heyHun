extends Node2D

@onready var timer = $Timer
@export var enemyScene: PackedScene
@export var numberOfEnemies: int
@export var timeBetweenEnemies: float

@onready var game_world = get_parent()

signal spawnerDepleted

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = timeBetweenEnemies

func _on_timer_timeout():
	if numberOfEnemies > 0:
		var enemy = enemyScene.instantiate()
		enemy.position = global_position
		add_child(enemy)
		enemy.connect("died", Callable(game_world, "enemy_died"))
		enemy.connect("dropCoins", Callable(game_world, "dropCoins"))
		timer.start()
		enemy.name = name + str(numberOfEnemies)
		numberOfEnemies -= 1

func start_wave():
	timer.start()
