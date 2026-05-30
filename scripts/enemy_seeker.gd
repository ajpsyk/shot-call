## An enemy which wanders from the top to the bottom of the screen until it
## sees a player, where it will rush down the player and explode into a few
## projectiles once in range.
extends Enemy


# ~~~~~ VARIABLES ~~~~~
## How many projectiles the Seeker will spawn when triggered.
@export var projectile_count: int = 8
## The speed multiplier the Seeker gains when rushing a player.
@export var pursuit_speed_factor: float = 3.0

@export var projectile_scene: PackedScene

var in_pursuit_mode: bool = false
var pursued_player: CharacterBody2D

# Child Node Refs
@onready var on_target_wait_timer: Timer = $OnTargetWait
@onready var trigger_timer: Timer = $TriggerTimer

@onready var tree_root: Node = get_tree().root

# ~~~~~ FUNCTIONALITY ~~~~~

func _ready() -> void:
	super()

	curr_speed = base_speed
	rotate(PI/2)
	if polarity == Globals.Polarity.NONE:
		set_random_polarity()
	velocity = Vector2.DOWN * curr_speed

func _physics_process(_delta: float) -> void:
	if in_pursuit_mode:
		look_at(pursued_player.position)
		velocity = Vector2.from_angle(rotation) * curr_speed
	
	move_and_slide()


# Start pursuing player when found
func _on_targeting_area_body_entered(body: Node2D) -> void:
	if !in_pursuit_mode and body.is_in_group("Player") and !body.dead:
		# enter pursuit mode
		in_pursuit_mode = true
		pursued_player = body
		curr_speed = 0
		on_target_wait_timer.start()
		await on_target_wait_timer.timeout
		curr_speed = base_speed * pursuit_speed_factor

# Trigger explosion when player is in range
func _on_trigger_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player") and !body.dead:
		curr_speed = 0
		trigger_timer.start()

func _on_trigger_timer_timeout() -> void:
	for i in range(projectile_count):
		spawn_projectile(TAU * i/projectile_count)
	queue_free()

func spawn_projectile(angle: float):
	if projectile_scene == null:
		push_warning("enemy_seeker.gd: Projectile scene not set")
		return
	var new_projectile: Area2D = projectile_scene.instantiate()
	new_projectile.rotation = angle
	new_projectile.global_position = global_position
	new_projectile.polarity = polarity
	tree_root.add_child(new_projectile)

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
