# A basic enemy which moves side to side near the top of the screen
# and shoots lasers at the player.
extends Enemy


# ~~~~~ VARIABLES ~~~~~

## Enemy lingers this many pixels from the screen's top edge.
@export var dist_from_top: int = 200
## Enemy will not get this many pixels close to the screen's left/right edges. Should never be greater than 1/2 of the viewport's width.
@export var dist_from_sides: int = 100
## Enemy will spawn this scene when firing a laser.
@export var laser_scene: PackedScene

var left_edge: int
var right_edge: int

# Child Node Refs
# @onready var hurtbox: Area2D = $Hurtbox
@onready var sprite: Sprite2D = $Sprite2D

const COLOR_BLUE = Color(0.5, 0.8, 1.0)
const COLOR_RED = Color(1.0, 0.5, 0.5)


# ~~~~~ FUNCTIONALITY ~~~~~

func _ready():
	var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	left_edge = dist_from_sides
	right_edge = screen_width - dist_from_sides
	
	if polarity == Globals.Polarity.NONE:
		set_random_polarity()
	
	if polarity == Globals.Polarity.RED:
		modulate = COLOR_RED
	else:
		modulate = COLOR_BLUE

func _physics_process(delta: float) -> void:
	position.y = move_toward(position.y, dist_from_top, move_speed/2*delta)
	if position.x < left_edge:
		velocity.x = move_speed
	elif position.x > right_edge:
		velocity.x = -move_speed

	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Laser"):
		if polarity == Globals.Polarity.NONE or ("polarity" in area and area.polarity == polarity):
			change_health(-1, area)
			flash_effect()
		else:
			deflect_effect()
		area.queue_free()


func _on_laser_fire_timer_timeout() -> void:
	var new_laser: Area2D = laser_scene.instantiate()
	new_laser.polarity = polarity
	new_laser.global_position = position
	get_tree().root.add_child(new_laser)


func flash_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	var original_color = COLOR_RED if polarity == Globals.Polarity.RED else COLOR_BLUE
	tween.tween_property(self, "modulate", original_color, 0.05)

func deflect_effect() -> void:
	var tween = create_tween()
	tween.tween_property(sprite, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(sprite, "scale", Vector2(1.0, 1.0), 0.1)