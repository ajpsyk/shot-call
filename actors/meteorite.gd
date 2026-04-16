extends Node2D

const METEOROID_SPRITES := [
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_big1.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_big2.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_big3.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_big4.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_med1.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_med3.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_small1.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_small2.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_tiny1.png"),
	preload("res://assets/kenney_space-shooter-remastered/PNG/Meteors/meteorBrown_tiny2.png")
]

enum Polarity { BLUE, RED }

const COLOR_BLUE = Color(0.2, 0.5, 1.0)
const COLOR_RED = Color(1.0, 0.2, 0.2)

class Meteoroid:
	var position := Vector2()
	var speed := 1.0
	var body := RID()
	var texture: Texture2D
	var polarity: Polarity
	var display_color: Color
	var active := false


func _ready() -> void:
	shape = PhysicsServer2D.circle_shape_create()
	# Set the collision shape's radius for each bullet in pixels.
	PhysicsServer2D.shape_set_data(shape, 8)

	for _i in BULLET_COUNT:
		var b := Bullet.new()
		# Give each bullet its own random speed.
		bullet.speed = randf_range(SPEED_MIN, SPEED_MAX)
		bullet.body = PhysicsServer2D.body_create()

		PhysicsServer2D.body_set_space(bullet.body, get_world_2d().get_space())
		PhysicsServer2D.body_add_shape(bullet.body, shape)
		# Don't make bullets check collision with other bullets to improve performance.
		PhysicsServer2D.body_set_collision_mask(bullet.body, 0)

		# Place bullets randomly on the viewport and move bullets outside the
		# play area so that they fade in nicely.
		bullet.position = Vector2(
				randf_range(0, get_viewport_rect().size.x) + get_viewport_rect().size.x,
				randf_range(0, get_viewport_rect().size.y)
			)
		var transform2d := Transform2D()
		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)

		bullets.push_back(bullet)


func _process(_delta: float) -> void:
	# Order the CanvasItem to update every frame.
	queue_redraw()


func _physics_process(delta: float) -> void:
	var transform2d := Transform2D()
	var offset := get_viewport_rect().size.x + 16
	for bullet: Bullet in bullets:
		bullet.position.x -= bullet.speed * delta

		if bullet.position.x < -16:
			# Move the bullet back to the right when it left the screen.
			bullet.position.x = offset

		transform2d.origin = bullet.position
		PhysicsServer2D.body_set_state(bullet.body, PhysicsServer2D.BODY_STATE_TRANSFORM, transform2d)


# Instead of drawing each bullet individually in a script attached to each bullet,
# we are drawing *all* the bullets at once here.
func _draw() -> void:
	var offset := -bullet_image.get_size() * 0.5
	for bullet: Bullet in bullets:
		draw_texture(bullet_image, bullet.position + offset)


# Perform cleanup operations (required to exit without error messages in the console).
func _exit_tree() -> void:
	for bullet: Bullet in bullets:
		PhysicsServer2D.free_rid(bullet.body)

	PhysicsServer2D.free_rid(shape)
	bullets.clear()
