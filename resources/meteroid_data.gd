extends Resource

class_name MeteoroidResource

@export var texture: Texture2D

## Collision radius based on the dimensions of the sprite.
## Calculated as: (min(width, height) / 2) * 0.8 [80% Mercy Rule]
## This prevents cheap deaths from transparent corner pixels.
@export var radius: float

@export var score: int
