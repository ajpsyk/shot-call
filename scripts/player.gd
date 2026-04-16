extends CharacterBody2D

# ~~~~~ VARIABLES ~~~~~

# ~ Game Logic ~

## Indicates which player number the player is (1 or 2) or that the player is playing singleplayer (0).
@export var playerNumber: int = 0

## The speed at which the player moves in pixels/second.
@export var moveSpeed: float = 300

enum Polarity{RED, BLUE}
var polarity: Polarity = Polarity.RED

# ~ Child Node References ~
@onready var redShipSprite: Sprite2D = $RedShipSprite
@onready var blueShipSprite: Sprite2D = $BlueShipSprite

func _ready() -> void:
	UpdateShipSprite()

# ~~~~~ FUNCTIONALITY ~~~~~

func _physics_process(delta: float) -> void:
	var xMovement: float 
	var yMovement: float 
	if playerNumber == 1:
		xMovement = Input.get_axis("p1_left", "p1_right")
		yMovement = Input.get_axis("p1_up", "p1_down")
	elif playerNumber == 2:
		xMovement = Input.get_axis("p2_left", "p2_right")
		yMovement = Input.get_axis("p2_up", "p2_down")

	var direction: Vector2 = Vector2(xMovement, yMovement).normalized()

	velocity = direction * moveSpeed

	move_and_slide()

func _input(event: InputEvent) -> void:
	# Handle action
	if playerNumber == 1 and event.is_action_pressed("p1_action"):
		get_viewport().set_input_as_handled()
		Action()
	if playerNumber == 2 and event.is_action_pressed("p2_action"):
		get_viewport().set_input_as_handled()
		Action()


func Fire():
	pass

func Action():
	# Only does a simple polarity switch for now. This is how it can function in singleplayer.
	if polarity == Polarity.RED:
		polarity = Polarity.BLUE
	elif polarity == Polarity.BLUE:
		polarity = Polarity.RED

	UpdateShipSprite()

## Called after Polarity updates, and in _ready() to set to initial polarity.
func UpdateShipSprite():
	if polarity == Polarity.RED:
		blueShipSprite.set_visible(false)
		redShipSprite.set_visible(true)
	elif polarity == Polarity.BLUE:
		redShipSprite.set_visible(false)
		blueShipSprite.set_visible(true)
