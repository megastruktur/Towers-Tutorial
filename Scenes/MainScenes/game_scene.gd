extends Node2D

var map_node : Node2D
var TowerExclusion : TileMap = null
var EnemyPath : Path2D = null

var build_mode = false
var build_valid = false
var build_location = null
var build_type = null
var color_build_valid = "adff4545"
var color_build_invalid = "ab54ff3c"

const turrets_res_path : String = "res://Scenes/Turrets/"
const enemies_res_path : String = "res://Scenes/Enemies/"

# Game settings
var start_wave_timer : float = 0.2
var prepare_stage_timer : float = 0.2
var current_wave : int = 0
var enemies_in_wave : int = 0
var speed_default : float = 1.0
var speed_speed_up : float = 2.0


func _ready():
	
	load_map()
	
	build_buttons_connect()
	current_wave = 0
	start_next_wave()
	

func load_map():
	map_node = get_node("Map1")
	EnemyPath = map_node.get_node("Path")
	TowerExclusion = map_node.get_node("TowerExclusion")


##
## Spawn Functions
##
func start_next_wave():
	
	var timer = start_wave_timer
	if current_wave == 0:
		timer = prepare_stage_timer
	
	await get_tree().create_timer(timer).timeout
	spawn_enemies(get_wave_data())
	
	
func spawn_enemies(wave_data):
	for i in wave_data:
		var new_enemy = load(enemies_res_path + i[0] + ".tscn").instantiate()
		EnemyPath.add_child(new_enemy, true)
		await get_tree().create_timer(i[1]).timeout
	
	
func get_wave_data():
	var wave_data = [["blue_tank", 0.7], ["blue_tank", 0.1]]
	current_wave += 1
	enemies_in_wave = wave_data.size()
	return wave_data
	

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
	

##
## General Game functions
##
func game_pause():
	
	if get_tree().is_paused():
		get_tree().paused = false
	else:
		get_tree().paused = true


func game_speed_toggle():
	
	if Engine.get_time_scale() == speed_speed_up:
		Engine.set_time_scale(speed_default)
	else:
		Engine.set_time_scale(speed_speed_up)


##
##	Build Functions
##
# Connect listeners to buttons.
func build_buttons_connect():
	
	# Get all build buttons
	for i in get_tree().get_nodes_in_group("build_buttons"):
		i.pressed.connect(initiate_build_mode.bind(i.get_name()))


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
			tower.built = true
			tower.position = build_location
			map_node.get_node("Turrets").add_child(tower, true)
			cancel_build_mode()
		else:
			print("No valid Tower resource found")
	else:
		print("Can't build here")

