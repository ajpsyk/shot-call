extends Node2D

@export var level_id: int
@export var level_splash_scene: PackedScene

func _ready() -> void:
	if not Globals.multiplayer_mode:
		Globals.players.erase($Player2)
		$Player2.queue_free()
		$"Score Overlay/P2ScoreContainer".queue_free()
		
	var splash = level_splash_scene.instantiate()
	splash.display_level(level_id)
	add_child(splash)
	
		

	if has_node("EnemySpawner"):
		$EnemySpawner.level_completed.connect(_on_level_completed)
	elif has_node("MeteoroidManager"):
		$MeteoroidManager.level_completed.connect(_on_level_completed)

func _on_level_completed() -> void:
	if level_id != 99:
		Globals.last_completed_level = level_id
		get_tree().change_scene_to_file("res://scenes/bonus.tscn")
	else:
		var next_scene_path = "res://scenes/level_2.tscn"
		
		if ResourceLoader.exists(next_scene_path):
			get_tree().change_scene_to_file(next_scene_path)
		else:
			get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
