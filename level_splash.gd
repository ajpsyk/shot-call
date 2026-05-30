extends CanvasLayer

signal splash_finished

@onready var label: Label = $Label
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var level_number_to_show: int = 1

func display_level(level_number: int) -> void:
	level_number_to_show = level_number

func _ready() -> void:
	
	if level_number_to_show == 99:
		label.text = "BONUS LEVEL"
	else:
		label.text = "LEVEL " + str(level_number_to_show)
	
	animation_player.play("fade_in_out")
	
	await animation_player.animation_finished
	splash_finished.emit()
	queue_free()
