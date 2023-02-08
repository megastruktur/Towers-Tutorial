extends Node2D

var map_node : Node2D

var build_mode = false
var build_valid = false
var build_location = null
var build_type = null
var color_build_valid = "adff4545"
var color_build_invalid = "ab54ff3c"


func _ready():
	
	map_node = get_node("Map1")
	build_buttons_connect()
	

# Connect listeners to buttons.
func build_buttons_connect():
	
	# Get all build buttons
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.get_name()))




func _process(_delta):
	
	if build_mode:
		update_tower_preview()
	
	
func _unhandled_input(_event):
	pass
	
	
func initiate_build_mode(tower_type : String):
	
	# cancel the prev build mode first
	cancel_build_mode()
	
	build_type = tower_type + "_t_1"
	build_mode = true
	$UI.set_tower_preview(build_type, get_global_mouse_position())
	
	
func update_tower_preview():
	var mouse_position : Vector2 = get_global_mouse_position()
	var TowerExclusion : TileMap = map_node.get_node("TowerExclusion")
	var current_tile : Vector2 = TowerExclusion.local_to_map(mouse_position)
	var tile_position : Vector2 = TowerExclusion.map_to_local(current_tile)
	
	# Searching for a valid build place
	for i in TowerExclusion.get_layers_count():
		
		if TowerExclusion.get_cell_source_id(i, current_tile) == -1:
			build_valid = true
		else:
			# Can't build as cell is occupied. Exit.
			build_valid = false
			break
	
	var color : String
	if build_valid:
		color = color_build_valid
		build_location = tile_position
	else:
		color = color_build_invalid
		
	get_node("UI").update_tower_preview(tile_position, color)


func cancel_build_mode():
	# cleanup the preview
	
	build_mode = false
	build_valid = false
	build_location = null
	build_type = null
	
	get_node("UI").cleanup_preview()
	
func verify_and_build():
	pass
