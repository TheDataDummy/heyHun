extends CharacterBody2D
@onready var navigation_agent_2d = $NavigationAgent2D
@export var standardSpeed: int = 25
@export var hitpoints: int = 1
@export var dropValue: int
@onready var slow_timer = $slowTimer
@onready var enemy_sprite = $enemySprite
@onready var hpbar = $hpbar
@onready var animation_player = $AnimationPlayer
@onready var hit_timer = $hitTimer
@onready var hit_splat = $hitSplat
@onready var hit_timer_cooldown = $hitTimerCooldown

var target: Node = null
var queuedHitpoints: int
var attacking = false
var speed: float
var debug = false
var moving = true

signal died(position: Vector2)
signal dropCoins(coins: int)

func _ready():
	if name + str(get_parent().numberOfEnemies) == "vaccine10":
		debug = true
	speed = standardSpeed
	_setup_navigation.call_deferred()
	target = get_tree().get_nodes_in_group("target")[0]
	queuedHitpoints = hitpoints
	hpbar.max_value = hitpoints
	hpbar.value = hitpoints

func _setup_navigation():
	if target:
		navigation_agent_2d.target_position = target.global_position

func _physics_process(_delta):
	if !navigation_agent_2d.is_target_reached() and hitpoints > 0:
		var nav_point_direction = to_local(navigation_agent_2d.get_next_path_position()).normalized()
		velocity = nav_point_direction * speed
		move_and_slide()

func made_it_home():
	kill(false)

func queue_damage(damage):
	queuedHitpoints -= damage
	if queuedHitpoints <= 0:
		queuedHitpoints = 0

func hit(damage):
	hitpoints -= damage
	hpbar.value = max(0, hitpoints)
	if not hit_timer.time_left > 0 and not hit_timer_cooldown.time_left > 0:
		hit_splat.visible = true
		hit_timer.start()

func kill(playerKilled = true):
	if playerKilled:
		dropCoins.emit(dropValue)
		died.emit(global_position)
	else:
		died.emit(global_position, false)
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

func _on_hit_timer_timeout():
	if hitpoints <= 0:
		kill()
		return
	hit_splat.visible = false
	hit_timer_cooldown.start()
