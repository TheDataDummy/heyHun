extends Node2D

@onready var timer = $Timer

@export var enemyScene: PackedScene
@export var numberOfEnemies: int
@export var timeBetweenEnemies: float

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = timeBetweenEnemies
	timer.start()

func _on_timer_timeout():
	if numberOfEnemies > 0:
		var enemy = enemyScene.instantiate()
		enemy.position = global_position
		add_child(enemy)
		timer.start()
		numberOfEnemies -= 1
