# A basic enemy which moves in a straight line from the top to the bottom of the screen.
extends Enemy


# ~~~~~ VARIABLES ~~~~~

# This enemy does not use Enemy.move_speed.
@export var min_speed: float = 80
@export var max_speed: float = 150
@export var hit_points: int

var sprite: Texture2D
var hitbox: float

const COLOR_BLUE = Color(0.2, 0.5, 1.0)
const COLOR_RED = Color(1.0, 0.2, 0.2)

@onready var spriteNode: Sprite2D = $Sprite2D

# ~~~~~ FUNCTIONALITY ~~~~~

func init(texture, radius, score) -> void:
	sprite = texture
	hitbox = radius
	score_value = score
	
func _ready() -> void:
	print("Spawned meteoroid")
	$Sprite2D.texture = sprite
	$Hurtbox/CollisionShape2D.shape.radius = hitbox
	velocity = Vector2.DOWN * randf_range(min_speed, max_speed)
	print("Velocity: ", velocity)
	
	set_random_polarity()
	if polarity == Globals.Polarity.RED:
		modulate = COLOR_RED
		set_collision_layer_value(3, true)
	else:
		modulate = COLOR_BLUE
		set_collision_layer_value(7, true)
	
func _physics_process(delta: float) -> void:
	move_and_slide()
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		queue_free()
	
	if area.is_in_group("Laser"):
		if area.polarity == polarity:
			change_health(-1, area)
			flash_effect()
		else:
			deflect_effect()


func flash_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	var original_color = COLOR_RED if polarity == Globals.Polarity.RED else COLOR_BLUE
	tween.tween_property(self, "modulate", original_color, 0.05)

func deflect_effect() -> void:
	var tween = create_tween()
	tween.tween_property(spriteNode, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(spriteNode, "scale", Vector2(1.0, 1.0), 0.1)
