extends Node

var tower_data = {
	"gun_t_1" : {
		"damage" : 20,
		"rof" : 1,
		"range" : 350,
		"category" : "projectile"
	},
	"gun_t_2" : {
		"damage" : 40,
		"rof" : 1,
		"range" : 400,
		"category" : "projectile"
	},
	"missle_t_1" : {
		"damage" : 100,
		"rof" : 3,
		"range" : 550,
		"category" : "missile"
	},
}

var enemies_data = {
	"blue_tank" : {
		"speed" : 200,
		"hp" : 300,
		"damage" : 21
	},
}


var wave_data = {
	"1" : [["blue_tank", 0.7], ["blue_tank", 0.1]],
	"2" : [["blue_tank", 0.7], ["blue_tank", 0.3], ["blue_tank", 0.3]],
}
