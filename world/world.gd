extends Node2D
@onready var play_area = $PlayArea
@onready var side_bar = $SideBar
@onready var hud = $HUD

@export var money: int
@export var health: int

var placementMode = false
var towerSelected = null

signal tower_slection_mode_entered(tower_name: String)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if Input.is_action_just_pressed("ui_down"):
		play_area.start_wave()

func _on_side_bar_tower_selected(tower_name):
	placementMode = true
	towerSelected = tower_name
	tower_slection_mode_entered.emit(tower_name)


func _on_play_area_build_mode_exited():
	side_bar.deselect_all_buttons()
