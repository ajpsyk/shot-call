extends Area2D

@onready var redLaser: Sprite2D = $RedLaser
@onready var blueLaser: Sprite2D = $BlueLaser

@export var speed: float = 800
var polarity: Globals.Polarity

func _ready() -> void:
	if polarity == Globals.Polarity.RED:
		redLaser.visible = true
		blueLaser.visible = false
		set_collision_layer_value(2, true)
		set_collision_layer_value(6, false)
		set_collision_mask_value(3, true)
		set_collision_mask_value(7, false)
	else:
		redLaser.visible = false
		blueLaser.visible = true
		set_collision_layer_value(2, false)
		set_collision_layer_value(6, true)
		set_collision_mask_value(3, false)
		set_collision_mask_value(7, true)
	
	

func _physics_process(delta: float) -> void:
	position += Vector2.UP * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
