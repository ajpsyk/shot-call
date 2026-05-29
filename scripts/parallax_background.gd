extends ParallaxBackground

@export var scroll_speed: int = 100

func _process(delta):
	scroll_offset.y += scroll_speed * delta
