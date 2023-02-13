extends PathFollow2D

var hp : int
var enemy_type : String

func _ready():
	hp = GameData.enemies_data[enemy_type]["hp"]


func _physics_process(delta):
	move(delta)
	
func move(delta):
	set_progress(get_progress() + GameData.enemies_data[enemy_type]["speed"] * delta)


func on_hit(damage):
	hp -= damage
	
	if hp <= 0:
		on_destroy()
		
		
func on_destroy():
	queue_free()


func set_type(type):
	enemy_type = type
