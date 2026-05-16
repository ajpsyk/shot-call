extends Enemy

@export var min_speed: float = 80
@export var max_speed: float = 150
@export var hit_points: int

var texture_to_use: Texture2D
var hitbox: float
var final_speed: float = 0.0
var polarity_is_preset: bool = false

func init(texture, radius, score, custom_speed: float = 0.0) -> void:
	texture_to_use = texture
	hitbox = radius
	score_value = score
	
	if custom_speed > 0.0:
		final_speed = custom_speed
	else:
		final_speed = randf_range(min_speed, max_speed)


func set_polarity(incoming_polarity: String) -> void:
	polarity_is_preset = true
	
	match incoming_polarity.to_lower():
		"red":
			polarity = Globals.Polarity.RED
		"blue":
			polarity = Globals.Polarity.BLUE
		_:
			polarity_is_preset = false
	
func _ready() -> void:
	super()
	
	sprite.texture = texture_to_use
	$Hurtbox/CollisionShape2D.shape.radius = hitbox
	velocity = Vector2.DOWN * final_speed
	
	if not polarity_is_preset:
		set_random_polarity()
		
	if polarity == Globals.Polarity.RED:
		sprite.modulate = COLOR_RED
		set_collision_layer_value(3, true)
	else:
		sprite.modulate = COLOR_BLUE
		set_collision_layer_value(7, true)
	
func _physics_process(_delta: float) -> void:
	move_and_slide()
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("Player"):
		queue_free()
	super(area)
