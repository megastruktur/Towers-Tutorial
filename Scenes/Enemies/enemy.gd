extends PathFollow2D

@onready var HealthBar : TextureProgressBar = $HealthBar

var hp : int
var enemy_type : String :
	get:
		return enemy_type
	set(value):
		enemy_type = value

func _ready():
	hp = GameData.enemies_data[enemy_type]["hp"]
	
	HealthBar.max_value = hp
	HealthBar.value = hp
	HealthBar.top_level = true
	
	print(get_name() + " current Health: " + str(hp))


func _physics_process(delta):
	move(delta)


func _set(var_name, value):
	match var_name:
		"enemy_type":
			enemy_type = value

	
func move(delta):
	set_progress(get_progress() + GameData.enemies_data[enemy_type]["speed"] * delta)
	HealthBar.position = position - Vector2(30, 30)


func on_hit(damage):
	
	print(get_name() + " was hit for damage " + str(damage))
	hp -= damage
	HealthBar.value = hp
	
	if hp <= 0:
		on_destroy()
		
		
func on_destroy():
	queue_free()
