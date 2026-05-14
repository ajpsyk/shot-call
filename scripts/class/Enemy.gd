extends CharacterBody2D
class_name Enemy
# A basic enemy which moves side to side near the top of the screen
# and shoots lasers at the player.


# ~~~~~ VARIABLES ~~~~~

## Speed of movement in pixels/second.
@export var move_speed: float = 300

@export var max_health: int = 5
var health: int = max_health

@export var score_value: int = 100

var polarity: Globals.Polarity = Globals.Polarity.NONE

# Child Node References
# Every Enemy is expected to have these nodes for basic functionality.

# ~~~~~ FUNCTIONALITY ~~~~~

# Overridable Node Functions

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	pass


# Overridable Helper Functions

# If overriden, should award points to the player which dealt the final blow.
func die(damage_source = null) -> void:
	if damage_source and "shooter_id" in damage_source:
		award_points(damage_source.shooter_id)
	queue_free()


# Helper functions - only override if you know what you're doing!

func change_health(amount: int, damage_source: Node2D = null) -> void:
	health += amount
	if health <= 0:
		die(damage_source)
	elif health > max_health:
		health = max_health

func award_points(player_num: int) -> void:
	# print(score_value, "pts for player ", player_num)
	if player_num == 1:
		Globals.player_1_score += score_value
	elif player_num == 2:
		Globals.player_1_score += score_value

func set_random_polarity() -> void:
	polarity = [Globals.Polarity.RED, Globals.Polarity.BLUE].pick_random()
