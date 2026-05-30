extends Node2D
signal level_completed

@export var BIG_METEOROIDS: Array[MeteoroidResource] = []
@export var MEDIUM_METEOROIDS: Array[MeteoroidResource] = []
@export var SMALL_METEOROIDS: Array[MeteoroidResource] = []

@export var meteor_scene: PackedScene
@export var seeker_scene: PackedScene

# Inspector dropdown to isolate sections for debugging
@export_enum("Full Level", "Minute 0-1", "Minute 1-2", "Minute 2-3", "Minute 3-4", "Minute 4-5") var test_section: String = "Full Level"

var time_elapsed: float = 0.0
var current_wave_index: int = 0
var spawn_timeline: Array = []

func _ready() -> void:
	generate_level()

func generate_level() -> void:
	match test_section:
		"Full Level":
			build_minute_0_to_1()
			build_minute_1_to_2()
			build_minute_2_to_3()
			build_minute_3_to_4()
			build_minute_4_to_5()
		"Minute 0-1":
			build_minute_0_to_1()
		"Minute 1-2":
			time_elapsed = 60.0
			build_minute_1_to_2()
		"Minute 2-3":
			time_elapsed = 120.0
			build_minute_2_to_3()
		"Minute 3-4":
			time_elapsed = 160.0
			build_minute_3_to_4()
		"Minute 4-5":
			time_elapsed = 210.0
			build_minute_4_to_5()
			
	spawn_timeline.sort_custom(func(a, b): return a["time"] < b["time"])
	
	current_wave_index = 0
	while current_wave_index < spawn_timeline.size() and time_elapsed > spawn_timeline[current_wave_index]["time"]:
		current_wave_index += 1

func build_minute_0_to_1() -> void:
	add_seeker(1.0, 0.32, "red", 180.0)
	add_seeker(2.5, 0.68, "blue", 180.0)
	add_seeker(6.0, 0.15, "blue", 200.0)
	add_seeker(6.0, 0.85, "red", 200.0)
	add_seeker_stream(11.0, 22.0, 1.5, 0.50, "mixed", 210.0)
	add_seeker(14.0, 0.32, "red", 220.0)
	add_seeker(18.0, 0.68, "blue", 220.0)
	add_single(23.0, 0.50, "medium", "red", 200.0)
	add_single(25.0, 0.32, "small", "blue", 250.0)
	add_single(25.0, 0.68, "small", "red", 250.0)
	add_stream(30.0, 45.0, 0.8, 0.50, "small", "mixed", 220.0)
	add_seeker(34.0, 0.20, "blue", 230.0)
	add_seeker(40.0, 0.80, "red", 230.0)
	add_single(49.0, 0.50, "big", "none", 300.0)
	add_seeker(52.0, 0.50, "mixed", 260.0)
	add_seeker(55.0, 0.25, "red", 240.0)
	add_seeker(58.0, 0.75, "blue", 240.0)

func build_minute_1_to_2() -> void:
	add_seeker_stream(60.0, 74.0, 1.2, 0.32, "mixed", 220.0)
	add_seeker_stream(61.0, 74.0, 1.2, 0.68, "mixed", 220.0)
	
	add_single(76.0, 0.15, "small", "red", 350.0)
	add_single(77.0, 0.85, "small", "blue", 350.0)
	add_seeker(78.0, 0.50, "red", 240.0)
	add_seeker(79.5, 0.50, "blue", 240.0)
	
	add_seeker_stream(83.0, 98.0, 0.9, 0.15, "blue", 230.0)
	add_seeker_stream(83.0, 98.0, 0.9, 0.85, "red", 230.0)
	add_seeker(100.0, 0.50, "mixed", 260.0)
	
	add_single(104.0, 0.50, "big", "mixed", 250.0)
	add_seeker(110.0, 0.32, "blue", 260.0)
	add_seeker(115.0, 0.68, "red", 260.0)

func build_minute_2_to_3() -> void:
	add_single(120.0, 0.85, "big", "red", 250.0)
	add_seeker(121.0, 0.15, "blue", 260.0)
	add_seeker(123.5, 0.32, "blue", 260.0)
	
	add_single(127.0, 0.15, "big", "blue", 250.0)
	add_seeker(128.0, 0.68, "red", 260.0)
	add_seeker(129.5, 0.85, "red", 260.0)
	
	add_stream(133.0, 155.0, 0.5, 0.15, "small", "none", 280.0) 
	add_stream(133.0, 155.0, 0.5, 0.85, "small", "none", 280.0) 
	add_seeker_stream(135.0, 154.0, 1.4, 0.50, "mixed", 250.0) 
	
	add_seeker(158.0, 0.20, "red", 270.0)
	add_seeker(161.0, 0.80, "blue", 270.0)

func build_minute_3_to_4() -> void:
	add_seeker_stream(164.0, 178.0, 3.5, 0.15, "red", 220.0)
	add_seeker_stream(166.0, 180.0, 3.5, 0.85, "blue", 220.0)
	
	add_seeker_stream(180.0, 194.0, 3.0, 0.32, "blue", 240.0)
	add_seeker_stream(182.0, 196.0, 3.0, 0.68, "red", 240.0)

	add_seeker(165.0, 0.50, "blue", 250.0)
	add_seeker(170.0, 0.50, "red", 250.0) 
	add_seeker(175.0, 0.50, "blue", 260.0)
	add_seeker(180.0, 0.50, "red", 260.0) 
	add_seeker(185.0, 0.50, "mixed", 270.0)

	add_seeker_stream(198.0, 208.0, 2.5, 0.50, "mixed", 250.0)
	add_seeker(200.0, 0.15, "red", 260.0)
	add_seeker(204.0, 0.85, "blue", 260.0)

func build_minute_4_to_5() -> void:
	add_seeker(208.0, 0.15, "red", 260.0)
	add_seeker(211.0, 0.85, "blue", 260.0)
	add_seeker(214.0, 0.50, "mixed", 280.0)
	
	add_seeker_stream(218.0, 238.0, 2.0, 0.15, "mixed", 260.0) 
	add_seeker_stream(224.0, 244.0, 2.0, 0.85, "mixed", 260.0) 
	add_seeker_stream(230.0, 250.0, 1.8, 0.50, "mixed", 280.0) 

	add_seeker_stream(255.0, 280.0, 2.2, 0.32, "red", 300.0)
	add_seeker_stream(258.0, 283.0, 2.2, 0.68, "blue", 300.0)
	
	add_seeker(288.0, 0.25, "red", 340.0)
	add_seeker(288.0, 0.75, "blue", 340.0)
	add_seeker(291.0, 0.50, "mixed", 350.0)
	add_single(294.0, 0.50, "big", "mixed", 350.0)

# ~~~~~ SPAWNING TIMELINE UTILITIES ~~~~~

func add_single(time: float, x_pct: float, tier: String, polarity: String, speed: float) -> void:
	spawn_timeline.append({"type": "meteor", "time": time, "x_pct": x_pct, "tier": tier, "polarity": polarity, "speed": speed})

func add_seeker(time: float, x_pct: float, polarity: String, speed: float) -> void:
	spawn_timeline.append({"type": "seeker", "time": time, "x_pct": x_pct, "polarity": polarity, "speed": speed})

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
	if interval <= 0.0: return
	var current_time = start_time
	var counter = 0
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_single(current_time, x_pct, tier, final_polarity, speed)
		current_time += interval
		counter += 1

func add_seeker_stream(start_time: float, end_time: float, interval: float, x_pct: float, polarity: String, speed: float) -> void:
	if interval <= 0.0: return
	var current_time = start_time
	var counter = 0
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_seeker(current_time, x_pct, final_polarity, speed)
		current_time += interval
		counter += 1

func add_zig_zag(start_time: float, end_time: float, interval: float, tier: String, polarity: String, speed: float) -> void:
	if interval <= 0.0: return
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

func add_choke_point_wall(time: float, open_index: int, open_polarity: String, speed: float) -> void:
	var horizontal_steps = [0.15, 0.32, 0.50, 0.68, 0.85]
	for i in range(horizontal_steps.size()):
		if i == open_index:
			add_single(time, horizontal_steps[i], "big", open_polarity, speed)
		else:
			add_single(time, horizontal_steps[i], "big", "none", speed)

func add_contained_zig_zag(start_time: float, end_time: float, interval: float, min_x: float, max_x: float, tier: String, polarity: String, speed: float) -> void:
	if interval <= 0.0: return
	var current_time = start_time
	var current_x = (min_x + max_x) / 2.0
	var step_amount = 0.10
	var moving_right = true
	var counter = 0
	
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_single(current_time, current_x, tier, final_polarity, speed)
		
		if moving_right:
			current_x += step_amount
			if current_x >= max_x:
				current_x = max_x
				moving_right = false
		else:
			current_x -= step_amount
			if current_x <= min_x:
				current_x = min_x
				moving_right = true
				
		current_time += interval
		counter += 1

func add_contained_wall(time: float, x_positions: Array, tier: String, polarity: String, speed: float) -> void:
	for i in range(x_positions.size()):
		var final_polarity = get_alternating_polarity(i, polarity)
		add_single(time, x_positions[i], tier, final_polarity, speed)


func _physics_process(delta: float) -> void:
	if current_wave_index >= spawn_timeline.size():
		time_elapsed += delta
		if time_elapsed >= 300.2:
			level_completed.emit()
			set_physics_process(false)
		return
	
	time_elapsed += delta
	var screen_width = get_viewport_rect().size.x
	
	while current_wave_index < spawn_timeline.size() and time_elapsed >= spawn_timeline[current_wave_index]["time"]:
		var spawn_data = spawn_timeline[current_wave_index]
		var calculated_x = spawn_data["x_pct"] * screen_width
		var polarity = spawn_data.get("polarity", "blue")
		var custom_speed = spawn_data.get("speed", 0.0)

		if spawn_data.get("type", "meteor") == "seeker":
			spawn_seeker(calculated_x, polarity, custom_speed)
		else:
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

func spawn_seeker(x_pos: float, polarity_str: String, custom_speed: float = 0.0) -> void:
	if not seeker_scene:
		return
		
	var seeker = seeker_scene.instantiate()
	
	if custom_speed > 0.0:
		seeker.base_speed = custom_speed
	
	if polarity_str == "red":
		seeker.polarity = Globals.Polarity.RED
	elif polarity_str == "blue":
		seeker.polarity = Globals.Polarity.BLUE
	else:
		seeker.polarity = [Globals.Polarity.RED, Globals.Polarity.BLUE].pick_random()
		
	seeker.global_position = Vector2(x_pos, -50)
	add_child(seeker)
