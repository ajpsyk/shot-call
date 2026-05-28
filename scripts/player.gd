extends CharacterBody2D

# ~~~~~ VARIABLES ~~~~~

# ~ Game Logic ~

## Indicates which player number the player is (1 or 2) or that the player is playing singleplayer (0).
## NOTE: Player 0 is currently unsupported.
@export var player_number: int = 0

## The speed at which the player moves in pixels/second.
@export var move_speed: float = 300

@export var laser_manager: Node2D

@export var fire_delay: float = 0.15

@export var max_health: int = 3
var health: int
var polarity: Globals.Polarity = Globals.Polarity.RED
var fire_timer: float = 0.0

var dead: bool = false

# ~ Child Node References ~
@onready var red_ship_sprite: Sprite2D = $RedShipSprite
@onready var blue_ship_sprite: Sprite2D = $BlueShipSprite

@onready var hurtbox: Area2D = $Hurtbox

@onready var health_rich_text_label: RichTextLabel = $HealthRichTextLabel


# ~~~~~ FUNCTIONALITY ~~~~~

# ~ Godot Overrides ~

func _ready() -> void:
	Globals.players.append(self)
	health = max_health
	update_ship_sprite()
	update_hurtbox_polarity()
	set_hurtbox_active(true)
	update_health_ui()
	set_global_position(Globals.get_spawn_point(player_number))
	dead = false

func _physics_process(delta: float) -> void:
	if not dead:
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
		
		if (player_number == 1 and Input.is_action_pressed("p1_fire")):
			get_viewport().set_input_as_handled()
			fire()
		if (player_number == 2 and Input.is_action_pressed("p2_fire")):
			get_viewport().set_input_as_handled()
			fire()

		move_and_slide()

func _input(event: InputEvent) -> void:
	if not dead:
		if player_number == 1 and event.is_action_pressed("p1_action"):
			get_viewport().set_input_as_handled()
			action()
		if player_number == 2 and event.is_action_pressed("p2_action"):
			get_viewport().set_input_as_handled()
			action()
		
		
	
	# Note: Action respawns player when dead. This is for ease of playtesting and should change when we implement an actual respawn mechanic.
	else:
		if (player_number == 1 and event.is_action_pressed("p1_action")) or (player_number == 2 and event.is_action_pressed("p2_action")):
			_ready()

func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("Enemy") or area.is_in_group("EnemyAtk"):
		# If area has polarity (e.g. area is an enemy laser)
		if "polarity" in area:
			if area.polarity != polarity:
				change_health(-1)
		# If area's parent has polarity (e.g. area is an enemy's hitbox)
		else:
			var area_parent := area.get_parent()
			if "polarity" in area_parent and area_parent.polarity != polarity:
					change_health(-1)
			


# ~ Helper Functions ~

func fire():
	if laser_manager and fire_timer >= fire_delay:
		laser_manager.fire_laser(global_position, polarity, player_number)
		fire_timer = 0.0

func action():
	# Only does a simple polarity switch for now. This is how it can function in singleplayer.
	if polarity == Globals.Polarity.RED:
		polarity = Globals.Polarity.BLUE
	elif polarity == Globals.Polarity.BLUE:
		polarity = Globals.Polarity.RED

	update_ship_sprite()
	update_hurtbox_polarity()

## Called after Polarity updates, and in _ready() to set to initial polarity.
func update_ship_sprite():
	if polarity == Globals.Polarity.RED:
		blue_ship_sprite.set_visible(false)
		red_ship_sprite.set_visible(true)
	elif polarity == Globals.Polarity.BLUE:
		red_ship_sprite.set_visible(false)
		blue_ship_sprite.set_visible(true)

func update_hurtbox_polarity():
	if polarity == Globals.Polarity.RED:
		hurtbox.set_collision_layer_value(2, true)
		hurtbox.set_collision_layer_value(6, false)
	elif polarity == Globals.Polarity.BLUE:
		hurtbox.set_collision_layer_value(2, false)
		hurtbox.set_collision_layer_value(6, true)

func change_health(amount: int):
	health += amount
	if health > max_health:
		health = max_health
	update_health_ui()
	if health <= 0:
		die()

func die():
	Globals.players.erase(self)
	dead = true
	blue_ship_sprite.set_visible(false)
	red_ship_sprite.set_visible(false)
	set_hurtbox_active(false)
	health_rich_text_label.set_text("Died! Press Action to respawn")
	# Call _ready() to respawn the player

func set_hurtbox_active(active: bool) -> void:
	hurtbox.set_deferred("monitoring", active)
	hurtbox.set_deferred("monitorable", active)


func update_health_ui():
	# We can change this function to call something on a UI element later.
	health_rich_text_label.set_text(str(health))
