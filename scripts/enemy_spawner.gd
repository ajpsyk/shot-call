extends Node2D

@export var BIG_METEOROIDS: Array[MeteoroidResource] = []
@export var MEDIUM_METEOROIDS: Array[MeteoroidResource] = []
@export var SMALL_METEOROIDS: Array[MeteoroidResource] = []

@export var meteor_scene: PackedScene

var time_elapsed: float = 0.0
var current_wave_index: int = 0
var spawn_timeline: Array = []

func _ready() -> void:
	generate_level()

func generate_level() -> void:
	add_single(5.0, 0.50, "big", "red", 120.0)
	add_single(10.0, 0.50, "big", "blue", 120.0)
	add_wall(15.0, "big", "red", 120.0)
	add_wall(22.0, "big", "blue", 120.0)
	add_stream(29.0, 33.0, 1.0, 0.15, "big", "blue", 120.0)
	add_stream(34.0, 38.0, 1.0, 0.85, "big", "red", 120.0)
	add_zig_zag(42.0, 54.0, 0.8, "big", 'red', 180.0)
	add_zig_zag(55.0, 66.0, 0.8, "big", 'blue', 180.0)
	
	add_single(72.0, 0.35, "big", "mixed", 130.0)
	add_single(75.0, 0.65, "big", "mixed", 130.0)
	
	add_wall(80.0, "big", "mixed", 120.0)
	add_wall(87.0, "big", "mixed", 120.0)
	
	add_stream(94.0, 100.0, 1.0, 0.25, "big", "mixed", 130.0)
	add_stream(94.0, 100.0, 1.0, 0.75, "big", "mixed", 130.0)
	

	add_zig_zag(106.0, 126.0, 0.7, "big", "mixed", 170.0)
	
	spawn_timeline.sort_custom(func(a, b): return a["time"] < b["time"])

func add_single(time: float, x_pct: float, tier: String, polarity: String, speed: float) -> void:
	spawn_timeline.append({"time": time, "x_pct": x_pct, "tier": tier, "polarity": polarity, "speed": speed})

func get_alternating_polarity(index: int, mode: String) -> String:
	if mode.to_lower() == "mixed":
		return "red" if index % 2 == 0 else "blue"
	return mode

func add_wall(time: float, tier: String, polarity: String, speed: float) -> void:
	var horizontal_steps = [0.15, 0.32, 0.50, 0.68, 0.85]
	for i in range(horizontal_steps.size()):
		var final_polarity = get_alternating_polarity(i, polarity)
		add_single(time, horizontal_steps[i], tier, final_polarity, speed)

func add_stream(start_time: float, end_time: float, interval: float, x_pct: float, tier: String, polarity: String, speed: float) -> void:
	var current_time = start_time
	var counter = 0
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_single(current_time, x_pct, tier, final_polarity, speed)
		current_time += interval
		counter += 1


func add_zig_zag(start_time: float, end_time: float, interval: float, tier: String, polarity: String, speed: float) -> void:
	var current_time = start_time
	var current_x = 0.50
	var step_amount = 0.10
	var moving_right = true
	var counter = 0
	
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_single(current_time, current_x, tier, final_polarity, speed)
		
		if moving_right:
			current_x += step_amount
			if current_x >= 0.85:
				current_x = 0.85
				moving_right = false
		else:
			current_x -= step_amount
			if current_x <= 0.15:
				current_x = 0.15
				moving_right = true
				
		current_time += interval
		counter += 1

func _physics_process(delta: float) -> void:
	if current_wave_index >= spawn_timeline.size():
		return
	
	time_elapsed += delta
	var screen_width = get_viewport_rect().size.x
	
	while current_wave_index < spawn_timeline.size() and time_elapsed >= spawn_timeline[current_wave_index]["time"]:
		var spawn_data = spawn_timeline[current_wave_index]
		var calculated_x = spawn_data["x_pct"] * screen_width
		var polarity = spawn_data.get("polarity", "blue")
		var custom_speed = spawn_data.get("speed", 0.0)

		spawn_meteor(calculated_x, spawn_data["tier"], polarity, custom_speed)
		current_wave_index += 1
		
func spawn_meteor(x_pos: float, tier: String, polarity: String, custom_speed: float = 0.0) -> void:
	if not meteor_scene:
		return
		
	var target_array: Array[MeteoroidResource] = []
	match tier:
		"big": target_array = BIG_METEOROIDS
		"medium": target_array = MEDIUM_METEOROIDS
		"small": target_array = SMALL_METEOROIDS
	
	if target_array.is_empty():
		return
		
	var template = target_array.pick_random()
	var meteor = meteor_scene.instantiate()
	meteor.init(template.texture, template.radius, template.score, custom_speed)
	
	if meteor.has_method("set_polarity"):
		meteor.set_polarity(polarity)
	else:
		meteor.polarity = polarity 
		
	meteor.global_position = Vector2(x_pos, -50)
	add_child(meteor)
