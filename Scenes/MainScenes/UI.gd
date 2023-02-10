extends CanvasLayer

var current_tower_preview : Control = null
const turrets_res_path = "res://Scenes/Turrets/"

var color_build_valid = "adff4545"
var color_build_invalid = "ab54ff3c"

func set_tower_preview(build_type : String, mouse_position):
		
	var turret_resource = load(turrets_res_path + build_type.to_lower() + ".tscn")
	if turret_resource:
		
		# Cleanup before setting the Preview.
		if current_tower_preview:
			cleanup_preview()
		
		# Create a Drag object
		
		## Create Tower drag texture
		var drag_tower : Node2D = turret_resource.instantiate()
		drag_tower.set_name("DragTower")
		drag_tower.modulate = Color(color_build_invalid)
		
		## Create Range texture
		var range_texture : Sprite2D = Sprite2D.new()
		range_texture.position = Vector2.ZERO
				
		var range_texture_scaling: float = drag_tower.tower_range / 600.0
		range_texture.scale = Vector2(range_texture_scaling, range_texture_scaling)
		
		print("Tower Range: " + str(drag_tower.tower_range))
		print("Tower Range Scale: " + str(Vector2(range_texture_scaling, range_texture_scaling)))
		
		range_texture.texture = load("res://Assets/UI/range_overlay.png")
		range_texture.modulate = Color(color_build_invalid)
		range_texture.set_name("TowerRange")
		
		# Create a Control wrapper.
		var tower_preview : Control = Control.new()
		tower_preview.position = mouse_position
		tower_preview.set_name("TowerPreview")
		
		tower_preview.add_child(drag_tower, true)
		tower_preview.add_child(range_texture, true)
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
		
		# Change Tower preview color
		var drag_tower : Node2D = current_tower_preview.get_node("DragTower")
		if drag_tower.modulate != Color(color):
			drag_tower.modulate = Color(color)
			
		# Change Tower Range preview color	
		var drag_tower_range : Node2D = current_tower_preview.get_node("TowerRange")
		if drag_tower_range.modulate != Color(color):
			drag_tower_range.modulate = Color(color)


func cleanup_preview():
	if current_tower_preview:
		current_tower_preview.queue_free()
		current_tower_preview = null
