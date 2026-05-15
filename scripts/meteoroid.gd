# A basic enemy which moves in a straight line from the top to the bottom of the screen.
extends Enemy


# ~~~~~ VARIABLES ~~~~~

# This enemy does not use Enemy.move_speed.
@export var min_speed: float = 80
@export var max_speed: float = 150
@export var hit_points: int

var texture_to_use: Texture2D
var hitbox: float

# ~~~~~ FUNCTIONALITY ~~~~~

func init(texture, radius, score) -> void:
	texture_to_use = texture
	hitbox = radius
	score_value = score
	
func _ready() -> void:
	super()
	print("Spawned meteoroid")
	sprite.texture = texture_to_use
	$Hurtbox/CollisionShape2D.shape.radius = hitbox
	velocity = Vector2.DOWN * randf_range(min_speed, max_speed)
	print("Velocity: ", velocity)
	
	set_random_polarity()
	if polarity == Globals.Polarity.RED:
		sprite.modulate = COLOR_RED
		set_collision_layer_value(3, true)
	else:
		sprite.modulate = COLOR_BLUE
		set_collision_layer_value(7, true)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	print("Meteoroid hurtbox area function")
	if area.get_parent().is_in_group("Player"):
		queue_free()
	# calls the base version of this function
	super(area)