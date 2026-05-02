extends Area2D

@export var min_speed: float
@export var max_speed: float
@export var hit_points: int

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
	else:
		modulate = COLOR_BLUE
		set_collision_layer_value(7, true)
	
func _physics_process(delta: float) -> void:
	position.y += speed * delta
	
	if position.y > get_viewport_rect().size.y + 100:
		queue_free()

func _on_area_entered(area: Area2D) -> void:
		
	if area.get_parent().is_in_group("Player"):
		queue_free()
	
	if area.is_in_group("Laser"):
		if area.polarity == polarity:
			hit_points -= 1
			flash_effect()
			if hit_points <= 0:
				award_points(area.shooter_id)
				queue_free()
		else:
			deflect_effect()	

func award_points(id: int) -> void:
	if id == 1:
		Globals.player_1_score += score_value
	elif id == 2:
		Globals.player_2_score += score_value
	print("Point for Player ", id)

func flash_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color.WHITE, 0.05)
	var original_color = COLOR_RED if polarity == Globals.Polarity.RED else COLOR_BLUE
	tween.tween_property(self, "modulate", original_color, 0.05)

func deflect_effect() -> void:
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1.2, 1.2), 0.05)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	
