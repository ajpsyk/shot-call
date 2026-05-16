extends Node

enum Polarity { NONE, RED, BLUE }

var spawn_points: Array[Marker2D] = [null, null, null]

var multiplayer_mode: bool = false

var player_1_score: int = 0
var player_2_score: int = 0


func get_spawn_point(player_number: int) -> Vector2:
	# Get cached spawn point if known
	if spawn_points[player_number]:
		print("Pulling cached spawn point for player %d" % player_number) #DEBUG
		return spawn_points[player_number].get_global_position()
	# Find spawn point if unknown
	if spawn_points[player_number] == null:
		var spawn_point: Marker2D = get_tree().root.find_child("Player"+str(player_number)+"Spawn", true, false)
		if spawn_point:
			print("Found and cached spawn point for player %d" % player_number) #DEBUG
			spawn_points[player_number] = spawn_point
			return spawn_point.get_global_position()
	
	push_warning("Failed to find spawn point Player%dSpawn" % player_number)
	return Vector2(0,1920)
