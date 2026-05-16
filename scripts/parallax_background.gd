extends ParallaxBackground

@export var scroll_speed: int = 1000

func _process(delta):
	scroll_offset.y += scroll_speed * delta
