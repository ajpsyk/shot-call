extends Enemy

# A basic boss enemy which moves side to side near the top of the screen,
# shoots lasers at the player, swaps polarity, and occasionally charges at the
# player at low health.


# ~~~~~ VARIABLES ~~~~~

## Enemy will spawn this scene when firing a laser.
@export var laser_scene: PackedScene

@export_group("Movement")
## Enemy lingers this many pixels from the screen's top edge.
@export var dist_from_top: int = 200
## Enemy will not get this many pixels close to the screen's left/right edges. Should never be greater than 1/2 of the viewport's width.
@export var dist_from_sides: int = 10

@export_group("Fire Rate")
@export var fire_rate_basic: float = 0.8
@export var fire_rate_enraged: float = 0.6
@export var fire_rate_lock_on: float = 0.3

@export_group("Enraged Mode")
@export var enraged_health_percent: float = 0.6
@export var speed_mult_enraged: float = 1.5
@export var speed_mult_charge: float = 2.0

var left_edge: int
var right_edge: int

var targeted_player: CharacterBody2D

var enraged: bool = false

enum Basic_Boss_State { INTRO, BASIC, LOCK_ON, CHARGE, NONE }
var curr_state: Basic_Boss_State = Basic_Boss_State.INTRO


# Child Node Refs
# @onready var hurtbox: Area2D = $Hurtbox
@onready var fire_timer: Timer = $FireTimer
@onready var polarity_swap_timer: Timer = $PolaritySwapTimer
@onready var basic_state_timer: Timer = $BasicStateDurationTimer
@onready var lock_on_state_timer: Timer = $LockOnStateDurationTimer
@onready var lock_on_delay_timer: Timer = $LockOnDelayTimer
@onready var post_charge_daze_timer: Timer = $PostChargeDazeTimer

@onready var white_flash: Sprite2D = $Sprite2D/WhiteFlash

@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var fire_sound: AudioStreamPlayer2D = $FireSound
@onready var polarity_swap_sound: AudioStreamPlayer2D = $PolaritySwapSound
@onready var lock_on_sound: AudioStreamPlayer2D = $LockOnSound
@onready var charge_prep_sound: AudioStreamPlayer2D = $ChargePrepSound
@onready var charge_dash_sound: AudioStreamPlayer2D = $ChargeDashSound
@onready var hurt_sound: AudioStreamPlayer2D = $HurtSound
@onready var absorb_sound: AudioStreamPlayer2D = $AbsorbSound

@onready var health_rich_text_label: RichTextLabel = $HealthLeft #DEBUG


# ~~~~~ FUNCTIONALITY ~~~~~

func _ready():
	super()

	# Bosses should have increased health if in multiplayer
	if Globals.multiplayer_mode:
		max_health *= 1.5
		health = max_health
	
	rotation = PI/2
	var screen_width: int = ProjectSettings.get_setting("display/window/size/viewport_width")
	left_edge = dist_from_sides
	right_edge = screen_width - dist_from_sides

func _physics_process(delta: float) -> void:
	health_rich_text_label.set_text(str(health))
	# Act based on state
	match curr_state:
		# Move in from off screen
		Basic_Boss_State.INTRO:
			if !is_equal_approx(position.y, dist_from_top):
				position.y = move_toward(position.y, dist_from_top, curr_speed*delta/2)

		# Move back and forth, firing at the player
		Basic_Boss_State.BASIC:
			if !is_equal_approx(position.y, dist_from_top):
				position.y = move_toward(position.y, dist_from_top, curr_speed*delta/2)
			
			if global_position.x < left_edge:
				velocity.x = curr_speed
			elif global_position.x > right_edge:
				velocity.x = -curr_speed

		# Lock onto a player and fire bursts of bullets
		Basic_Boss_State.LOCK_ON:
			if targeted_player:
				look_at(targeted_player.global_position)

		# Lock onto a player and charge at them, then reappear at the top of the screen
		Basic_Boss_State.CHARGE:
			if !lock_on_delay_timer.is_stopped() and targeted_player:
				look_at(targeted_player.global_position)
		
	move_and_slide()

	if not enraged and health <= max_health * enraged_health_percent:
		enraged = true
		curr_speed = base_speed * speed_mult_enraged
		change_state(Basic_Boss_State.NONE)
		animation_player.play("enraged_transition")
		await animation_player.animation_finished
		change_state(Basic_Boss_State.CHARGE)


# Leaving and entering states
func change_state(state: Basic_Boss_State):
	print("[Basic Boss] Transition from ", Basic_Boss_State.keys()[curr_state], " to ", Basic_Boss_State.keys()[state]) #DEBUG
	# Exit previous state
	match curr_state:
		Basic_Boss_State.INTRO:
			set_hurtbox_active(true)

		Basic_Boss_State.BASIC:
			fire_timer.stop()
			polarity_swap_timer.stop()

		Basic_Boss_State.LOCK_ON:
			fire_timer.stop()

		Basic_Boss_State.CHARGE:
			pass

		Basic_Boss_State.NONE:
			pass


	curr_state = state

	# Enter new state
	match state:
		Basic_Boss_State.BASIC:
			rotation = PI/2
			change_polarity()
			if enraged:
				fire_timer.start(fire_rate_enraged)
			else:
				fire_timer.start(fire_rate_basic)

			polarity_swap_timer.start()
			basic_state_timer.start()
			velocity = Vector2(curr_speed, 0)

		Basic_Boss_State.LOCK_ON:
			if polarity == Globals.Polarity.RED:
				targeted_player = Globals.get_player_of_polarity(Globals.Polarity.BLUE)
			else:
				targeted_player = Globals.get_player_of_polarity(Globals.Polarity.RED)
			velocity = Vector2.ZERO
			lock_on_delay_timer.start()
			lock_on_state_timer.start()
			lock_on_sound.play()

		Basic_Boss_State.CHARGE:
			if polarity == Globals.Polarity.RED:
				targeted_player = Globals.get_player_of_polarity(Globals.Polarity.BLUE)
			else:
				targeted_player = Globals.get_player_of_polarity(Globals.Polarity.RED)
			velocity = Vector2(0,-20)
			lock_on_delay_timer.start()
			charge_prep_sound.play()

		Basic_Boss_State.NONE:
			velocity = Vector2.ZERO
			fire_timer.stop()
			polarity_swap_timer.stop()
			basic_state_timer.stop()
			lock_on_state_timer.stop()
			lock_on_delay_timer.stop()
			post_charge_daze_timer.stop()
			animation_player.play("RESET")
		

func change_polarity() -> void:
	if polarity == Globals.Polarity.NONE:
		set_random_polarity()
	
	if polarity == Globals.Polarity.BLUE:
		polarity = Globals.Polarity.RED
	else:
		polarity = Globals.Polarity.BLUE
	update_polarity_color()

	polarity_swap_sound.play()

func take_damage_effect() -> void:
	var tween = create_tween()
	tween.tween_property(white_flash, "modulate", Color(1,1,1,0.5), 0.05)
	tween.tween_property(white_flash, "modulate", Color(1,1,1,0), 0.05)
	hurt_sound.play()

func absorb_damage_effect() -> void:
	super()
	absorb_sound.play()


func die(damage_source = null) -> void:
	set_hurtbox_active(false)
	change_state(Basic_Boss_State.NONE)
	if damage_source and "shooter_id" in damage_source:
		award_points(damage_source.shooter_id)
	animation_player.play("death")
	await animation_player.animation_finished
	queue_free()


func _on_laser_fire_timer_timeout() -> void:
	var new_laser: Area2D = laser_scene.instantiate()
	new_laser.polarity = polarity
	new_laser.global_position = global_position
	new_laser.global_rotation = global_rotation
	get_tree().root.add_child(new_laser)
	animation_player.play("fire_recoil")
	fire_sound.play()

func _on_polarity_swap_timer_timeout() -> void:
	change_polarity()


func _on_intro_timer_timeout() -> void:
	change_state(Basic_Boss_State.BASIC)

func _on_basic_state_timer_timeout() -> void:
	if enraged:
		change_state(Basic_Boss_State.CHARGE)
	else:
		change_state(Basic_Boss_State.LOCK_ON)

func _on_lock_on_state_duration_timer_timeout() -> void:
	change_state(Basic_Boss_State.BASIC)

func _on_lock_on_delay_timer_timeout() -> void:
	if curr_state == Basic_Boss_State.LOCK_ON:
		fire_timer.start(fire_rate_lock_on)
	elif curr_state == Basic_Boss_State.CHARGE:
		charge_dash_sound.play()
		velocity = Vector2.from_angle(global_rotation).normalized() * curr_speed * speed_mult_charge

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	global_rotation = 90
	position.y = -100
	position.x = clampf(position.x, left_edge, right_edge)
	if curr_state == Basic_Boss_State.CHARGE:
		velocity = Vector2.DOWN * curr_speed * 0.2
		post_charge_daze_timer.start()

func _on_post_charge_daze_timer_timeout() -> void:
	change_state(Basic_Boss_State.BASIC)
