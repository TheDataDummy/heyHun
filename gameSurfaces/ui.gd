extends CanvasLayer

func set_tower_preview(tower_name, mouse_position):
	var drag_tower = load("res://towers/" + tower_name + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.get_node("tower").modulate = Color("fa005d8e")
	drag_tower.get_node("cooldownbar").visible = false

	var control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	drag_tower.show_range_indicator()

func update_tower_preview(new_position, colorString):
	get_node("TowerPreview").position = new_position
	if get_node("TowerPreview/DragTower/tower").modulate != Color(colorString):
		get_node("TowerPreview/DragTower/tower").modulate = Color(colorString)	
