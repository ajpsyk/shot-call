extends Control

@onready var star = $Star
@onready var singlePlayerButton = $"Single Player"
@onready var coopButton = $"Co-op"
@onready var creditsButton = $Credits
@onready var quitButton = $Quit

func _ready():
	singlePlayerButton.focus_entered.connect(_on_button_focused.bind(singlePlayerButton))
	coopButton.focus_entered.connect(_on_button_focused.bind(coopButton))
	creditsButton.focus_entered.connect(_on_button_focused.bind(creditsButton))
	quitButton.focus_entered.connect(_on_button_focused.bind(quitButton))
	
	singlePlayerButton.mouse_entered.connect(_on_mouse_entered.bind(singlePlayerButton))
	coopButton.mouse_entered.connect(_on_mouse_entered.bind(coopButton))
	creditsButton.mouse_entered.connect(_on_mouse_entered.bind(creditsButton))
	quitButton.mouse_entered.connect(_on_mouse_entered.bind(quitButton))
	
	singlePlayerButton.grab_focus()

func _on_button_focused(focused_button: Button):
	var button_pos = focused_button.global_position
	var button_size = focused_button.size
	
	star.global_position.y = button_pos.y + (button_size.y / 2) - (star.size.y / 2)
	star.global_position.x = button_pos.x - star.size.x - 10

func _on_mouse_entered(hovered_button: Button):
	hovered_button.grab_focus()


func _on_credits_pressed() -> void:
	pass # Replace with function body.
