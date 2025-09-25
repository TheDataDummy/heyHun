# CloudSpawner.gd (Attached to a Node or Node2D in your main scene)
extends Node

# --- EXPORT VARIABLES ---
@export var cloud_scene: PackedScene # Drag your Cloud.tscn here
@export var min_spawn_time: float = 4.0 # Minimum seconds between clouds
@export var max_spawn_time: float = 8.0 # Maximum seconds between clouds
@export var initial_spawn_time: float = 0.1

# Screen dimensions are 640x360
var spawn_x_pos: int = -128        # Spawn clouds slightly off-screen to the right of 640
var spawn_area_top: int = 30      # Start Y position (near the top)
var spawn_area_bottom: int = 360  # End Y position (mid-screen, keep them above the ground)
var max_clouds: int = 1

# --- READY ---
func _ready():
	# Always call this once at the start of the game
	randomize() 
	
	# 1. Create a Timer node dynamically (or use one added in the editor)
	var spawn_timer = Timer.new()
	add_child(spawn_timer)
	spawn_timer.name = "spawnTimer"
	
	# 2. Connect the timeout signal
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	
	# 3. Start the timer with a random interval
	spawn_timer.wait_time = initial_spawn_time
	spawn_timer.start()

# --- HELPER FUNCTIONS ---

# Sets a random wait time for the next cloud spawn
func _set_random_timer(timer: Timer):
	timer.wait_time = randf_range(min_spawn_time, max_spawn_time)

# --- SIGNAL FUNCTION ---

# The function that runs when the timer times out
func _on_spawn_timer_timeout():
	var spawn_timer = get_node("spawnTimer") as Timer # Get the timer we created

	var current_clouds = 0
	for node in get_children():
		if not node is Timer:
			current_clouds += 1
			
	if current_clouds > max_clouds:
		_set_random_timer(spawn_timer)
		spawn_timer.start()
		return
		
	if not cloud_scene:
		# Check if the scene is set, if not, do nothing
		return

	# 1. Create a new cloud instance
	var new_cloud = cloud_scene.instantiate()
	
	# 2. Get a random Y position within the defined range
	var random_y = randi_range(spawn_area_top, spawn_area_bottom)
	
	# 3. Set the cloud's starting position (off-screen right)
	new_cloud.position = Vector2(spawn_x_pos, random_y)
	
	# 4. Add the new cloud to the current scene's parent (your main level node)
	add_child(new_cloud)
	
	# 5. Reset the timer for a new random interval and restart it
	_set_random_timer(spawn_timer)
	spawn_timer.start()
