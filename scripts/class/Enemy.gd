extends CharacterBody2D
# A basic enemy which moves side to side near the top of the screen
# and shoots lasers at the player.

## Speed of movement in pixels/second.
@export var move_speed: float = 300
## Enemy lingers this many pixels from the screen's top edge.
@export var dist_from_top: int = 270
## Enemy will not get this many pixels close to the screen's left/right edges. Should never be greater than 1/2 of the viewport's width.
@export var dist_from_sides: int = 135

var left_edge: int
var right_edge: int

func _ready():
	var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	left_edge = dist_from_sides
	right_edge = screen_width - dist_from_sides
	
	velocity.x = move_speed

func _physics_process(delta: float) -> void:
	position.y = move_toward(position.y, dist_from_top, move_speed/2*delta)
	if position.x < left_edge:
		velocity.x = move_speed
	elif position.x > right_edge:
		velocity.x = -move_speed

	move_and_slide()
