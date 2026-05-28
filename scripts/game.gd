extends Node2D


func _ready() -> void:
	if not Globals.multiplayer_mode:
		Globals.players.erase($Player2)
		$Player2.queue_free()
		$"Score Overlay/P2ScoreContainer".queue_free()
