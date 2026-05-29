extends CanvasLayer

@onready var p1_bar: TextureProgressBar = $P1HealthBar
@onready var p2_bar: TextureProgressBar = $P2HealthBar
@onready var p1_respawn_text: RichTextLabel = $P1RespawnText
@onready var p2_respawn_text: RichTextLabel = $P2RespawnText

func _ready() -> void:
	p1_respawn_text.visible = false
	p2_respawn_text.visible = false
	if !Globals.multiplayer_mode:
		p2_bar.visible = false

func update_health_bar(player: int, health: int):
	if player == 1:
		p1_bar.value = health
		if health == 0:
			p1_respawn_text.visible = true
		else:
			p1_respawn_text.visible = false

	elif player == 2:
		p2_bar.value = health
		if health == 0:
			p2_respawn_text.visible = true
		else:
			p2_respawn_text.visible = false
