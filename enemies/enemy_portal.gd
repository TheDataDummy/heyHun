extends Node2D

signal spawnCoin(pos: Vector2)
signal earnCoins(coins: int)
signal waveOver(name: String)

var portals_spawned

# Called when the node enters the scene tree for the first time.
func _ready():
	var portal_spawn_pos = get_tree().get_nodes_in_group("portal_spawn")
	for portal in portal_spawn_pos:
		if str(portals_spawned) in portal.name:
			global_position = portal.global_position
			start_wave()
		

func start_wave():
	for node in get_children():
		if not node is Sprite2D and not node is AnimationPlayer:
			node.start_wave()
