extends Node


func _ready():
	main_menu_connect()
	
	
	
func main_menu_connect():
	
	get_node("MainMenu/M/VB/NewGame").pressed.connect(on_new_game_pressed)
	get_node("MainMenu/M/VB/Settings").pressed.connect(on_settings_pressed)
	get_node("MainMenu/M/VB/About").pressed.connect(on_about_pressed)
	get_node("MainMenu/M/VB/Quit").pressed.connect(on_quit_pressed)
	
	
func on_new_game_pressed():
	# Remove Main Menu completely
	get_node("MainMenu").queue_free()
	var game_scene = load("res://Scenes/MainScenes/game_scene.tscn").instantiate()
	add_child(game_scene)


func on_settings_pressed():
	pass

	
func on_about_pressed():
	pass

	
func on_quit_pressed():
	get_tree().quit()
