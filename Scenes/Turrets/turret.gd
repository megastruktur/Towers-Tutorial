extends Node2D

@onready var turret : Sprite2D = $Turret
var enemy_array : Array[PathFollow2D] = []
var built : bool = false
var shoot_radius : float
var tracking_enemy : PathFollow2D = null
var type : String

func _ready():
	
	if built:
		shoot_radius = 0.5 * GameData.tower_data[type]["range"]
		get_node("Range/CollisionShape2D").get_shape().radius = shoot_radius


# On every physics Frame
func _physics_process(_delta):
	if enemy_array.size() != 0 and built:
		select_enemy()
		turn()
	else:
		tracking_enemy = null


func select_enemy():
	
	# That progress logic is needed because we can't simply select [0]
	#	as in this case if the Enemy leaves Collision and then enters back
	#	it will be treated as a less valuable target.
	#	But with Progress we select the most dangerous (closest to the base)
	#	target.
	var enemy_progress_array : Array = []
	
	for i in enemy_array:
		enemy_progress_array.append(i.get_progress())
	var max_offset = enemy_progress_array.max()
	var enemy_index = enemy_progress_array.find(max_offset)
	tracking_enemy = enemy_array[enemy_index]


func turn():
	if tracking_enemy:
		turret.look_at(tracking_enemy.position)


func _on_range_body_entered(body):
	# Add enemy to enemies array
	enemy_array.append(body.get_parent())
	print(enemy_array)


func _on_range_body_exited(body):
	enemy_array.erase(body.get_parent())
