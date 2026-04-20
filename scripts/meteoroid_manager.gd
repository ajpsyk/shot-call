extends Node2D

@export var BIG_METEOROIDS: Array[MeteoroidResource] = []
@export var MEDIUM_METEOROIDS: Array[MeteoroidResource] = []
@export var SMALL_METEOROIDS: Array[MeteoroidResource] = []

@export var meteor_scene: PackedScene

@export var starting_spawn_delay: float = 1.5
@export var final_spawn_delay: float = 0.2
@export var spawn_rate: float = 0.98
@export var medium_spawn_delay: float = 30.0
@export var small_spawn_delay: float = 60.0

var active_templates: Array[MeteoroidResource] = []

var timer: float = 0.0
var time_elapsed: float = 0.0
var current_delay: float
var medium_added: bool
var small_added: bool


func _ready() -> void:
	current_delay = starting_spawn_delay
	active_templates.append_array(BIG_METEOROIDS)
	
func _physics_process(delta: float) -> void:
	timer += delta
	time_elapsed += delta
	
	if not medium_added and time_elapsed > medium_spawn_delay:
		active_templates.append_array(MEDIUM_METEOROIDS)
		medium_added = true
	if not small_added and time_elapsed > small_spawn_delay:
		active_templates.append_array(SMALL_METEOROIDS)
		small_added = true
	
	if timer >= current_delay:
		spawn_meteor()
		timer = 0.0
		current_delay = max(final_spawn_delay, current_delay * spawn_rate)
		
func spawn_meteor() -> void:
	var meteor = meteor_scene.instantiate()
	var template = active_templates.pick_random()
	meteor.init(template.texture, template.radius, template.score)
	
	var screen_width = get_viewport_rect().size.x
	var x_pos = randf_range(0, screen_width)
	meteor.global_position = Vector2(x_pos, -100)
	
	add_child(meteor)


	
