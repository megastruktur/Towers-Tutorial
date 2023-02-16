extends PathFollow2D

@onready var HealthBar : TextureProgressBar = $HealthBar
@onready var ImpactArea : Marker2D = $Impact

signal enemy_dead
signal base_damage(damage)
var damage : int

# Preload to save some processing power
var projectile_impact = preload("res://Scenes/Support/projectile_impact.tscn")

var hp : int
var enemy_type : String :
	get:
		return enemy_type
	set(value):
		enemy_type = value


func _ready():
	hp = GameData.enemies_data[enemy_type]["hp"]
	damage = GameData.enemies_data[enemy_type]["damage"]
	
	HealthBar.max_value = hp
	HealthBar.value = hp
	HealthBar.top_level = true


func _physics_process(delta):
	deal_damage()
	move(delta)


func _set(var_name, value):
	match var_name:
		"enemy_type":
			enemy_type = value

	
func move(delta):
	set_progress(get_progress() + GameData.enemies_data[enemy_type]["speed"] * delta)
	HealthBar.position = position - Vector2(30, 30)


func deal_damage():
	# If the tank reaches the end of line - deal damage and destroy the object.
	if progress_ratio == 1.0:
		emit_signal("base_damage", damage)
		emit_signal("enemy_dead")
		queue_free()
		


func on_hit(received_damage):
	
	impact()
	
	hp -= received_damage
	HealthBar.value = hp
	
	if hp <= 0:
		on_destroy()
		
		
func impact():
	# change random seed with randomize()
	randomize()
	# return a random value between 0 and % X-1
	var x_pos = randi() % 31
	randomize()
	var y_pos = randi() % 31
	var impact_location : Vector2 = Vector2(x_pos, y_pos)
	var new_impact : AnimatedSprite2D = projectile_impact.instantiate()
	new_impact.position = impact_location
	ImpactArea.add_child(new_impact)
		
		
func on_destroy():
	get_node("CharacterBody2D").queue_free()
	emit_signal("enemy_dead")
	await get_tree().create_timer(0.2).timeout
	queue_free()
