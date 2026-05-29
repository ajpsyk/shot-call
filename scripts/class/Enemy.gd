extends CharacterBody2D
class_name Enemy
## An adversary to the player.
##
## This class is an extension of CharacterBody2D with custom functionality for basic enemy behavior:
## responding to incoming player attacks, taking damage, dying, and awarding points.
## [br][br]
## Many of these behaviors are meant to be overridden, allowing for custom behaviors and animations.


# ~~~~~ VARIABLES ~~~~~

## Base movement speed in pixels/second.
@export var base_speed: float = 300
var curr_speed: float
## Hits taken before this enemy is defeated.
@export var max_health: int = 5
var health: int
## How many points the player is awarded for defeating this enemy.
@export var score_value: int = 100

var polarity: Globals.Polarity = Globals.Polarity.NONE


# Child Node References
# Every Enemy is expected to have these nodes for basic functionality.
@export var sprite: Sprite2D
@export var hurtbox: Area2D

const COLOR_BLUE = Color(0.2, 0.5, 1.0)
const COLOR_RED = Color(1.0, 0.2, 0.2)

@onready var base_sprite_size: Vector2 = sprite.get("scale")

# ~~~~~ FUNCTIONALITY ~~~~~

# Overridable Node Functions

func _ready() -> void:
	health = max_health
	curr_speed = base_speed

	# If Hurtbox.area_entered isn't already connected to a custom function, connect it to the default function
	if !hurtbox.area_entered.has_connections():
		hurtbox.area_entered.connect(_on_hurtbox_area_entered)
	
	update_polarity_color()

func _physics_process(_delta: float) -> void:
	pass


# Overridable Helper Functions

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Laser"):
		if polarity == Globals.Polarity.NONE or ("polarity" in area and area.polarity == polarity):
			change_health(-1, area)
			take_damage_effect()
		else:
			absorb_damage_effect()
		area.queue_free()

func take_damage_effect() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "self_modulate", Color.WHITE, 0.05)
	var original_color = COLOR_RED if polarity == Globals.Polarity.RED else COLOR_BLUE
	tween.tween_property(sprite, "self_modulate", original_color, 0.05)

func absorb_damage_effect() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", base_sprite_size * 1.2, 0.05)
	tween.tween_property(sprite, "scale", base_sprite_size, 0.1)

# If overriden, should award points to the player which dealt the final blow.
func die(damage_source = null) -> void:
	if damage_source and "shooter_id" in damage_source:
		award_points(damage_source.shooter_id)
	queue_free()

func update_polarity_color() -> void:
	if polarity == Globals.Polarity.RED:
		sprite.self_modulate = COLOR_RED
	elif polarity == Globals.Polarity.BLUE:
		sprite.self_modulate = COLOR_BLUE


# Helper functions - only override if you know what you're doing!

func change_health(amount: int, damage_source: Node2D = null) -> void:
	health += amount
	if health <= 0:
		die(damage_source)
	elif health > max_health:
		health = max_health

func award_points(player_num: int) -> void:
	if player_num == 1:
		Globals.player_1_score += score_value
	elif player_num == 2:
		Globals.player_2_score += score_value

func set_hurtbox_active(active: bool) -> void:
	hurtbox.set_deferred("monitoring", active)
	hurtbox.set_deferred("monitorable", active)

func set_random_polarity() -> void:
	polarity = [Globals.Polarity.RED, Globals.Polarity.BLUE].pick_random()
	update_polarity_color()
