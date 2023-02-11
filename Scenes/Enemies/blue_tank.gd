extends PathFollow2D

func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + GameData.enemies_data["blue_tank"]["speed"] * delta)
