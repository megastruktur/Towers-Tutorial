extends CanvasLayer

var current_tower_preview : Control = null
const turrets_res_path = "res://Scenes/Turrets/"

func set_tower_preview(build_type : String, mouse_position):
		
	var turret_resource = load(turrets_res_path + build_type.to_lower() + ".tscn")
	if turret_resource:
		
		# Cleanup before setting the Preview.
		if current_tower_preview:
			cleanup_preview()
		
		print("Adding a Drag Tower")
		var drag_tower : Node2D = turret_resource.instantiate()
		drag_tower.set_name("DragTower")
		drag_tower.modulate = Color("ab54ff3c")
		
		# Create a Control wrapper.
		var tower_preview : Control = Control.new()
		tower_preview.position = mouse_position
		tower_preview.set_name("TowerPreview")
		
		tower_preview.add_child(drag_tower, true)
		add_child(tower_preview, true)
		
		# Save the reference to a current preview for Remove functionality.
		# I've faced the problem when queue_free works AFTER a new preview is created.
		# So in future code I'm going to call it by reference.
		current_tower_preview = tower_preview
		move_child(current_tower_preview, 0) # move behind the button
	else:
		print("Turret resource was not found")


func update_tower_preview(new_position: Vector2, color : String):
	
	# Move preview with the mouse	
	if current_tower_preview:
		
		current_tower_preview.position = new_position
		
		var drag_tower : Node2D = current_tower_preview.get_node("DragTower")
		if drag_tower.modulate != Color(color):
			drag_tower.modulate = Color(color)


func cleanup_preview():
	if current_tower_preview:
		current_tower_preview.queue_free()
		current_tower_preview = null
