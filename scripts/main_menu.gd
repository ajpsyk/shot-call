extends Node2D


func _on_single_player_pressed() -> void:
	Globals.multiplayer_mode = false
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_coop_pressed() -> void:
	Globals.multiplayer_mode = true
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()
