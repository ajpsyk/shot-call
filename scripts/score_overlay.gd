extends CanvasLayer


@onready var p1_label = $P1ScoreContainer/P1ScoreLabel
@onready var p2_label = $P2ScoreContainer/P2ScoreLabel

func _ready():
	update_scores()

func _process(_delta):
	update_scores()

func update_scores():
	
	p1_label.text = str(Globals.player_1_score).pad_zeros(6)
	if Globals.multiplayer_mode:
		p2_label.text = str(Globals.player_2_score).pad_zeros(6)
