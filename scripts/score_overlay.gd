extends CanvasLayer


@onready var p1_label = $HUD/HBoxContainer/P1ScoreContainer/ScoreLabel
@onready var p2_label = $HUD/HBoxContainer/P2ScoreContainer/ScoreLabel

func _ready():
	update_scores()

func _process(_delta):
	update_scores()

func update_scores():
	p1_label.text = str(Globals.player_1_score)
	p2_label.text = str(Globals.player_2_score)
