extends Area2D

@export var min_speed: float
@export var max_speed: float

var speed: float = 0.0
var sprite: Texture2D
var hitbox: float
var score_value: int = 0
var polarity: Globals.Polarity
const COLOR_BLUE = Color(0.2, 0.5, 1.0)
const COLOR_RED = Color(1.0, 0.2, 0.2)



func init(texture, radius, score) -> void:
	sprite = texture
	hitbox = radius
	score_value = score
	
func _ready() -> void:
	$Sprite2D.texture = sprite
	$CollisionShape2D.shape.radius = hitbox
	speed = randf_range(min_speed, max_speed)
	polarity = Globals.Polarity.values().pick_random()
	if polarity == Globals.Polarity.RED:
		modulate = COLOR_RED
		set_collision_layer_value(3, true)
		set_collision_layer_value(7, false)
		set_collision_mask_value(2, true)
		set_collision_mask_value(6, false)
	else:
		modulate = COLOR_BLUE
		set_collision_layer_value(3, false)
		set_collision_layer_value(7, true)
		set_collision_mask_value(2, false)
		set_collision_mask_value(6, true)
		
	modulate = COLOR_RED if polarity == Globals.Polarity.RED else COLOR_BLUE
	
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(_area: Area2D) -> void:
	print("Hit!")
	queue_free()
