extends CanvasLayer


func set_tower_preview(build_type : String, mouse_position):
	var drag_tower : Node2D = load("res://Scenes/Turrets/" + build_type.to_lower() + ".tscn").instantiate()
	drag_tower.set_name("DragTower")
	drag_tower.modulate = Color("ab54ff3c")
	
	var control = Control.new()
	control.add_child(drag_tower, true)
	control.position = mouse_position
	control.set_name("TowerPreview")
	add_child(control, true)
	move_child(get_node("TowerPreview"), 0) # move behind the button


func update_tower_preview(new_position: Vector2, color : String):
	
	# Move preview with the mouse
	get_node("TowerPreview").position = new_position
	
	var drag_tower : Node2D = get_node("TowerPreview/DragTower")
	if drag_tower.modulate != Color(color):
		drag_tower.modulate = Color(color)

func cleanup_preview():
	if get_node_or_null("TowerPreview"):
		remove_child(get_node("TowerPreview"))
