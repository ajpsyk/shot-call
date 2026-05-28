extends Enemy

# A basic boss enemy which moves side to side near the top of the screen,
# shoots lasers at the player, swaps polarity, and occasionally charges at the
# player at low health.


# ~~~~~ VARIABLES ~~~~~

## Enemy lingers this many pixels from the screen's top edge.
@export var dist_from_top: int = 200
## Enemy will not get this many pixels close to the screen's left/right edges. Should never be greater than 1/2 of the viewport's width.
@export var dist_from_sides: int = 100
## Enemy will spawn this scene when firing a laser.
@export var laser_scene: PackedScene

@export var fire_rate_basic: float = 0.8
@export var fire_rate_lock_on: float = 0.3

const SPEED_MULT_ENRAGED: float = 1.5
const SPEED_MULT_CHARGE: float = 4.0


var left_edge: int
var right_edge: int

var targeted_player: CharacterBody2D

enum BASIC_BOSS_STATE { INTRO, BASIC, LOCK_ON, CHARGE, NONE }
var curr_state: BASIC_BOSS_STATE = BASIC_BOSS_STATE.INTRO


# Child Node Refs
# @onready var hurtbox: Area2D = $Hurtbox
@onready var fire_timer: Timer = $FireTimer
@onready var polarity_swap_timer: Timer = $PolaritySwapTimer
@onready var basic_state_timer: Timer = $BasicStateDurationTimer
@onready var lock_on_state_timer: Timer = $LockOnStateDurationTimer
@onready var lock_on_delay_timer: Timer = $LockOnDelayTimer

@onready var health_rich_text_label: RichTextLabel = $HealthLeft

# ~~~~~ FUNCTIONALITY ~~~~~

func _ready():
	super()

	rotation = PI/2
	var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	left_edge = dist_from_sides
	right_edge = screen_width - dist_from_sides

func _physics_process(delta: float) -> void:
	health_rich_text_label.set_text(str(health))
	# Act based on state
	match curr_state:
		# Move in from off screen
		BASIC_BOSS_STATE.INTRO:
			if !is_equal_approx(position.y, dist_from_top):
				position.y = move_toward(position.y, dist_from_top, curr_speed*delta/2)

		# Move back and forth, firing at the player
		BASIC_BOSS_STATE.BASIC:
			if global_position.x < left_edge:
				velocity.x = curr_speed
			elif global_position.x > right_edge:
				velocity.x = -curr_speed

		# Lock onto a player and fire bursts of bullets
		BASIC_BOSS_STATE.LOCK_ON:
			if targeted_player:
				look_at(targeted_player.global_position)

		# Lock onto a player and charge at them, then reappear at the top of the screen
		BASIC_BOSS_STATE.CHARGE:
			pass
		
	move_and_slide()


# Leaving and entering states
func change_state(state: BASIC_BOSS_STATE):
	# Exit previous state
	match curr_state:
		BASIC_BOSS_STATE.INTRO:
			hurtbox.set("monitoring", true)

		BASIC_BOSS_STATE.BASIC:
			fire_timer.stop()
			polarity_swap_timer.stop()

		BASIC_BOSS_STATE.LOCK_ON:
			global_rotation = 0

		BASIC_BOSS_STATE.CHARGE:
			pass

	print("[Basic Boss] Exiting", curr_state)
	curr_state = state
	print("[Basic Boss] Entering", curr_state)

	# Enter new state
	match state:
		BASIC_BOSS_STATE.BASIC:
			rotation = PI/2
			change_polarity()
			fire_timer.start(fire_rate_basic)
			polarity_swap_timer.start()
			basic_state_timer.start()
			velocity.x = curr_speed

		BASIC_BOSS_STATE.LOCK_ON:
			print("[Basic Boss] Players: ", Globals.players)
			targeted_player = Globals.players.pick_random()
			velocity = Vector2(0,0)
			lock_on_delay_timer.start()

		BASIC_BOSS_STATE.CHARGE:
			targeted_player = Globals.players.pick_random()
			velocity = Vector2(0,0)
		

func change_polarity() -> void:
	if polarity == Globals.Polarity.NONE:
		set_random_polarity()
	
	if polarity == Globals.Polarity.BLUE:
		print("Setting polarity to red")
		polarity = Globals.Polarity.RED
		sprite.modulate = COLOR_RED
	else:
		print("Setting polarity to blue")
		polarity = Globals.Polarity.BLUE
		sprite.modulate = COLOR_BLUE


func _on_intro_timer_timeout() -> void:
	change_state(BASIC_BOSS_STATE.BASIC)

func _on_laser_fire_timer_timeout() -> void:
	var new_laser: Area2D = laser_scene.instantiate()
	new_laser.polarity = polarity
	new_laser.global_position = global_position
	new_laser.global_rotation = global_rotation
	get_tree().root.add_child(new_laser)

func _on_polarity_swap_timer_timeout() -> void:
	change_polarity()


func _on_basic_state_timer_timeout() -> void:
	# if health > max_health / 2:
		change_state(BASIC_BOSS_STATE.LOCK_ON)
	# else:
	# 	change_state(BASIC_BOSS_STATE.CHARGE)

func _on_lock_on_state_duration_timer_timeout() -> void:
	change_state(BASIC_BOSS_STATE.BASIC)

func _on_lock_on_delay_timer_timeout() -> void:
	fire_timer.start(fire_rate_lock_on)
