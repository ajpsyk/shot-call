extends Node2D

var screen_size : Vector2

@export var METEOROID_TEMPLATES: Array[MeteoroidResource] = []

const COUNT: int = 50
const SPEED_MIN = 20
const SPEED_MAX = 80

const COLOR_BLUE = Color(0.2, 0.5, 1.0)
const COLOR_RED = Color(1.0, 0.2, 0.2)


var meteoroids: Array[Meteoroid] = []

class Meteoroid:
	var position : Vector2 = Vector2()
	var speed : float = 1.0
	var body := RID()
	var hitbox := RID()
	var texture: Texture2D
	var polarity: Globals.Polarity
	var display_color: Color
	var active : bool = false


func _ready() -> void:
	
	screen_size = get_viewport_rect().size
	
	for _i in COUNT:
		var meteoroid := Meteoroid.new()
		
		meteoroid.polarity = Globals.Polarity.values().pick_random()
		if meteoroid.polarity == Globals.Polarity.RED:
			meteoroid.display_color = COLOR_RED
		else:
			meteoroid.display_color = COLOR_BLUE
		
		var template = METEOROID_TEMPLATES.pick_random()
		meteoroid.texture = template.texture
		meteoroid.speed = randf_range(SPEED_MIN, SPEED_MAX)
		
		meteoroid.hitbox = PhysicsServer2D.circle_shape_create()
		PhysicsServer2D.shape_set_data(meteoroid.hitbox, template.radius)
		
		meteoroid.body = PhysicsServer2D.body_create()
		PhysicsServer2D.body_set_space(meteoroid.body, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(meteoroid.body, meteoroid.hitbox)
		PhysicsServer2D.body_set_collision_layer(meteoroid.body, Globals.PhysicsLayers.ENEMY)
		PhysicsServer2D.body_set_collision_mask(meteoroid.body, 0)

		meteoroid.position = Vector2(
				randf_range(0, get_viewport_rect().size.x),
				randf_range(-1000, 0)
			)
		var transform2d := Transform2D()
		transform2d.origin = meteoroid.position
		PhysicsServer2D.body_set_state(meteoroid.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

		meteoroids.push_back(meteoroid)


func _process(_delta: float) -> void:
	queue_redraw()


func _physics_process(delta: float) -> void:
	var transform2d := Transform2D()
	
	for meteoroid: Meteoroid in meteoroids:
		meteoroid.position.y += meteoroid.speed * delta

		if meteoroid.position.y > screen_size.y + 100:
			meteoroid.position = Vector2(
				randf_range(0, screen_size.x),
				-100
			)

		transform2d.origin = meteoroid.position
		PhysicsServer2D.body_set_state(meteoroid.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

func _draw() -> void:
	for meteoroid: Meteoroid in meteoroids:
		var tex_size = meteoroid.texture.get_size()
		var rect = Rect2(meteoroid.position - tex_size * 0.5, tex_size)
		draw_texture_rect(meteoroid.texture, rect, false, meteoroid.display_color)

func _exit_tree() -> void:
	for meteoroid: Meteoroid in meteoroids:
		PhysicsServer2D.free_rid(meteoroid.body)
		PhysicsServer2D.free_rid(meteoroid.hitbox)
	
	meteoroids.clear()
