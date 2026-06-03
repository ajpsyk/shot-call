extends Node2D

@onready var camera: Camera2D = $Camera2D
@onready var main_menu_camera_position: Marker2D = $MainMenuCameraPosition
@onready var credits_camera_position: Marker2D = $CreditsCameraPosition
@onready var button_manager: Control = $"Button Manager"

var viewing_credits: bool = false

func _ready() -> void:
	camera.position = main_menu_camera_position.position

func _on_single_player_pressed() -> void:
	Globals.multiplayer_mode = false
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_coop_pressed() -> void:
	Globals.multiplayer_mode = true
	get_tree().change_scene_to_file("res://scenes/level_1.tscn")


func _on_credits_pressed() -> void:
	camera.position = credits_camera_position.position
	viewing_credits = true
	for button in button_manager.get_children():
		if button.is_class("Button"):
			button.disabled = true

func _input(event: InputEvent) -> void:
	if viewing_credits and event.is_action_pressed("ui_back"):
		get_viewport().set_input_as_handled()
		camera.position = main_menu_camera_position.position
		viewing_credits = false
		for button in button_manager.get_children():
			if button.is_class("Button"):
				button.disabled = false


func _on_quit_pressed() -> void:
	get_tree().quit()
