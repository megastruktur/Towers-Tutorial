extends Node


func _ready():
	main_menu_connect()
	
	
	
func main_menu_connect():
	
	if not get_node("MainMenu/M/VB/NewGame").is_connected("pressed", on_new_game_pressed):
		get_node("MainMenu/M/VB/NewGame").pressed.connect(on_new_game_pressed)
	if not get_node("MainMenu/M/VB/Settings").is_connected("pressed", on_settings_pressed):
		get_node("MainMenu/M/VB/Settings").pressed.connect(on_settings_pressed)
	if not get_node("MainMenu/M/VB/About").is_connected("pressed", on_about_pressed):
		get_node("MainMenu/M/VB/About").pressed.connect(on_about_pressed)
	if not get_node("MainMenu/M/VB/Quit").is_connected("pressed", on_quit_pressed):
		get_node("MainMenu/M/VB/Quit").pressed.connect(on_quit_pressed)
	
	
func on_new_game_pressed():
	# Remove Main Menu completely
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	game_scene.connect("game_finished", _on_game_finished)
	add_child(game_scene)


func on_settings_pressed():
	pass

	
func on_about_pressed():
	pass

	
func on_quit_pressed():
	get_tree().quit()


func _on_game_finished(is_won):
	get_node("GameScene").queue_free()
	
	var main_menu = load("res://Scenes/UI/main_menu.tscn").instantiate()
	add_child(main_menu)
	main_menu_connect()
	
	if is_won:
		print("Game Won")
	else:
		print("Game Lost")
