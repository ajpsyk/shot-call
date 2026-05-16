extends Node2D


func _ready() -> void:
	if not Globals.multiplayer_mode:
		$Player2.queue_free()
		$"Score Overlay/P2ScoreContainer".queue_free()
