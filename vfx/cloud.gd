extends Area2D

@export var min_speed: float = 8 # Slowest movement
@export var max_speed: float = 25 # Fastest movement (Adjust for your feel)
@onready var sprite_2d = $Sprite2D

var speed: float
var direction: Vector2 = Vector2.RIGHT # Clouds move left across the screen

func _ready():
	# 1. Randomize Speed
	speed = randf_range(min_speed, max_speed)
	# 2. Randomly flip the sprite for visual variety
	if sprite_2d:
		sprite_2d.flip_h = randi_range(0, 1) == 1

func _process(delta: float):
	# Move the cloud horizontally
	position += direction * speed * delta

	# Check if the cloud is completely off-screen to the left (640 screen width)
	# We check for -100 to ensure the whole sprite, regardless of size, is gone.
	if position.x > 1000:
		queue_free() # Delete the cloud instance
