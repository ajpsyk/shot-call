extends Node2D

@export var laser_scene: PackedScene

func fire_laser(start_pos: Vector2, laser_polarity: Globals.Polarity) -> void:
	var new_laser = laser_scene.instantiate()
	
	new_laser.position = start_pos
	new_laser.polarity = laser_polarity
	
	add_child(new_laser)
	
