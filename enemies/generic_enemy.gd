extends CharacterBody2D
@onready var navigation_agent_2d = $NavigationAgent2D
@export var standardSpeed: int = 25
@export var hitpoints: int = 1
@export var dropValue: int
@onready var slow_timer = $slowTimer
@onready var enemy_sprite = $enemySprite

var target: Node = null
var queuedHitpoints: int
var attacking = false
var speed: float

signal died(position: Vector2)
signal dropCoins(coins: int)

func _ready():
	speed = standardSpeed
	_setup_navigation.call_deferred()
	target = get_tree().get_nodes_in_group("target")[0]
	queuedHitpoints = hitpoints

func _setup_navigation():
	if target:
		navigation_agent_2d.target_position = target.global_position

func _physics_process(_delta):
	if !navigation_agent_2d.is_target_reached():
		var nav_point_direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed
		move_and_slide()

func made_it_home():
	queue_free()

func queue_damage(damage):
	#print(str(damage) + " has been queued on " + name)
	queuedHitpoints -= damage
	if queuedHitpoints <= 0:
		queuedHitpoints = 0
	#print(str(queuedHitpoints) + " currently queued hp")

func hit(damage):
	hitpoints -= damage
	if hitpoints <= 0:
		kill()

func kill():
	dropCoins.emit(dropValue)
	died.emit(global_position)
	queue_free()

func _on_slow_timer_timeout():
	enemy_sprite.self_modulate = Color("ffffff")
	speed = standardSpeed

func slow(fraction: float, duration: float):
	if slow_timer.is_stopped():
		enemy_sprite.self_modulate = Color("008c21")
		slow_timer.wait_time = duration
		slow_timer.start()
		speed = speed * fraction
