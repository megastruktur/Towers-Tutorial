extends Node2D

@onready var turret : Sprite2D = $Turret


# On every physics Frame
func _physics_process(_delta):
	turn()


func turn():
	var enemy_position = get_global_mouse_position()
	turret.look_at(enemy_position)
