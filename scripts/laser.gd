extends Area2D

@export var move_speed: float = 800
var polarity: Globals.Polarity
var shooter_id: int
var velocity: Vector2

@onready var redLaser: Sprite2D = $RedLaser
@onready var blueLaser: Sprite2D = $BlueLaser

func _ready() -> void:
	if polarity == Globals.Polarity.RED:
		redLaser.visible = true
		blueLaser.visible = false
	else:
		redLaser.visible = false
		blueLaser.visible = true
	velocity = Vector2.UP * move_speed


func _physics_process(delta: float) -> void:
	position += velocity * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()
