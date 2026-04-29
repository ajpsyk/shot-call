extends CharacterBody2D

# ~~~~~ VARIABLES ~~~~~

# ~ Game Logic ~

## Indicates which player number the player is (1 or 2) or that the player is playing singleplayer (0).
@export var player_number: int = 0

## The speed at which the player moves in pixels/second.
@export var move_speed: float = 300

@export var laser: Node2D

@export var fire_delay: float = 0.15


var polarity: Globals.Polarity = Globals.Polarity.RED
var fire_timer: float = 0.0

# ~ Child Node References ~
@onready var red_ship_sprite: Sprite2D = $RedShipSprite
@onready var blue_ship_sprite: Sprite2D = $BlueShipSprite


# ~~~~~ FUNCTIONALITY ~~~~~

func _ready() -> void:
	update_ship_sprite()

func _physics_process(delta: float) -> void:
	var x_movement: float 
	var y_movement: float 
	if player_number == 1:
		x_movement = Input.get_axis("p1_left", "p1_right")
		y_movement = Input.get_axis("p1_up", "p1_down")
	elif player_number == 2:
		x_movement = Input.get_axis("p2_left", "p2_right")
		y_movement = Input.get_axis("p2_up", "p2_down")

	var direction: Vector2 = Vector2(x_movement, y_movement).normalized()

	velocity = direction * move_speed
	
	fire_timer += delta

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Handle action
	if player_number == 1 and event.is_action_pressed("p1_action"):
		get_viewport().set_input_as_handled()
		action()
	if player_number == 2 and event.is_action_pressed("p2_action"):
		get_viewport().set_input_as_handled()
		action()
	
	if (player_number == 1 and event.is_action_pressed("p1_fire")):
		get_viewport().set_input_as_handled()
		fire()
	if (player_number == 2 and event.is_action_pressed("p2_fire")):
		get_viewport().set_input_as_handled()
		fire()


func fire():
	if laser and fire_timer >= fire_delay:
		laser.fire_laser(global_position, polarity)
		fire_timer = 0.0

func action():
	# Only does a simple polarity switch for now. This is how it can function in singleplayer.
	if polarity == Globals.Polarity.RED:
		polarity = Globals.Polarity.BLUE
	elif polarity == Globals.Polarity.BLUE:
		polarity = Globals.Polarity.RED

	update_ship_sprite()

## Called after Polarity updates, and in _ready() to set to initial polarity.
func update_ship_sprite():
	if polarity == Globals.Polarity.RED:
		blue_ship_sprite.set_visible(false)
		red_ship_sprite.set_visible(true)
	elif polarity == Globals.Polarity.BLUE:
		red_ship_sprite.set_visible(false)
		blue_ship_sprite.set_visible(true)
