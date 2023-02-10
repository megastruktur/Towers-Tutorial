extends Node2D

var map_node : Node2D
var TowerExclusion : TileMap = null

var build_mode = false
var build_valid = false
var build_location = null
var build_type = null
var color_build_valid = "adff4545"
var color_build_invalid = "ab54ff3c"

const turrets_res_path = "res://Scenes/Turrets/"



func _ready():
	
	load_map()
	build_buttons_connect()
	

func load_map():
	map_node = get_node("Map1")
	TowerExclusion = map_node.get_node("TowerExclusion")

# Connect listeners to buttons.
func build_buttons_connect():
	
	# Get all build buttons
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.get_name()))


func _process(_delta):
	
	if build_mode:
		update_tower_preview()
	

# User input was not consumed by the UI
# E.g. we are NOT clicking the Start Game.
func _unhandled_input(event):
	
	if build_mode:
		if event.is_action_pressed("ui_cancel"):
			cancel_build_mode()
		if event.is_action_pressed("ui_accept"):
			# First verify then cancel because cancel is going to clear
			#	all the variables for verification
			verify_and_build()
	
	
func initiate_build_mode(tower_type : String):
	
	# cancel the prev build mode first
	cancel_build_mode()
	
	build_type = tower_type + "_t_1"
	build_mode = true
	$UI.set_tower_preview(build_type, get_global_mouse_position())
	
	
func update_tower_preview():
	var mouse_position : Vector2 = get_global_mouse_position()
	var current_tile : Vector2 = TowerExclusion.local_to_map(mouse_position)
	var tile_position : Vector2 = TowerExclusion.map_to_local(current_tile)
	
	var color : String
	if is_build_place_valid(current_tile, tile_position):
		color = color_build_valid
		build_location = tile_position
	else:
		color = color_build_invalid
		
	get_node("UI").update_tower_preview(tile_position, color)


func is_build_place_valid(current_tile: Vector2, tile_position: Vector2) -> bool:
		
	# Searching for a valid build place
	for i in TowerExclusion.get_layers_count():
		
		if TowerExclusion.get_cell_source_id(i, current_tile) == -1:
			build_valid = true
		else:
			# Can't build as cell is occupied. Exit.
			build_valid = false
			break
	
	# Check towers
	var turrets = map_node.get_node("Turrets").get_children()
	for i in turrets:
		if i.position == tile_position:
			build_valid = false
			break
	
	return build_valid


func cancel_build_mode():
	# cleanup the preview	
	build_mode = false
	build_valid = false
	build_location = null
	build_type = null
	
	get_node("UI").cleanup_preview()


func verify_and_build():
	
	if build_valid:
		var new_tower = load(turrets_res_path + build_type.to_lower() + ".tscn")
		if new_tower:
			var tower : Node2D = new_tower.instantiate()
			tower.position = build_location
			map_node.get_node("Turrets").add_child(tower, true)
			cancel_build_mode()
		else:
			print("No valid Tower resource found")
	else:
		print("Can't build here")
