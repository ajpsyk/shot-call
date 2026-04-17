extends Area2D

@onready var redLaser: Sprite2D = $RedLaser
@onready var blueLaser: Sprite2D = $BlueLaser

@export var speed: float = 800
var polarity: Globals.Polarity

func _ready() -> void:
	if polarity == Globals.Polarity.RED:
		redLaser.visible = true
		blueLaser.visible = false
	else:
		redLaser.visible = false
		blueLaser.visible = true

func _physics_process(delta: float) -> void:
	position += Vector2.UP * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
