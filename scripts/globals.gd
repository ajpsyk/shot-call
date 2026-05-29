extends Node

enum Polarity { NONE, RED, BLUE }

var players: Array[CharacterBody2D]

var spawn_points: Array[Marker2D] = [null, null, null]

var multiplayer_mode: bool = false

var player_1_score: int = 0
var player_2_score: int = 0

@onready var health_overlay: CanvasLayer

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
	return Vector2(270,900)

# Returns the first Player in players list with the desired polarity.
# If not found (singleplayer, a player is down), defaults to the first Player in the list.
# If list is empty (all players are down), returns null.
# If you want to get a random player, you can use Globals.players.pick_random().
func get_player_of_polarity(pol: Polarity) -> CharacterBody2D:
	for player in players:
		if "polarity" in player and player.polarity == pol:
			return player
	
	if players.is_empty():
		return null
	else:
		return players[0]


func update_health_bar(player: int, health: int):
	if health_overlay == null:
		health_overlay = get_tree().root.find_child("HealthOverlay", true, false)

	if health_overlay:
		health_overlay.update_health_bar(player, health)
	else:
		push_warning("[Globals] Health overlay object not found")
