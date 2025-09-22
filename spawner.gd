extends Node2D

@onready var timer = $Timer
@export var enemyScene: PackedScene
@export var numberOfEnemies: int
@export var timeBetweenEnemies: float
@export var timeBeforeEnemiesSpawn: float

@onready var wave_start_delay_timer = $waveStartDelayTimer
@onready var game_world = get_parent()

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = timeBetweenEnemies
	if timeBeforeEnemiesSpawn == 0:
		timeBeforeEnemiesSpawn = 0.1
	wave_start_delay_timer.wait_time = timeBeforeEnemiesSpawn

func _on_timer_timeout():
	if numberOfEnemies > 0:
		var enemy = enemyScene.instantiate()
		enemy.position = global_position
		add_child(enemy)
		enemy.connect("died", Callable(game_world, "enemy_died"))
		enemy.connect("dropCoins", Callable(game_world, "dropCoins"))
		timer.start()
		numberOfEnemies -= 1

func start_wave():
	wave_start_delay_timer.start()

func _on_wave_start_delay_timer_timeout():
		timer.start()
