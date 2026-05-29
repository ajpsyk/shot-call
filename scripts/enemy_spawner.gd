extends Node2D

@export var BIG_METEOROIDS: Array[MeteoroidResource] = []
@export var MEDIUM_METEOROIDS: Array[MeteoroidResource] = []
@export var SMALL_METEOROIDS: Array[MeteoroidResource] = []

@export var meteor_scene: PackedScene

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
	add_single(2.0, 0.50, "big", "red", 200.0)
	add_single(4.0, 0.50, "big", "blue", 200.0)
	add_wall(7.0, "big", "red", 200.0)
	add_wall(11.0, "big", "blue", 200.0)
	add_stream(15.0, 22.0, 0.5, 0.15, "big", "red", 220.0)
	add_stream(23.0, 30.0, 0.5, 0.85, "big", "blue", 220.0)
	add_zig_zag(34.0, 45.0, 0.4, "big", 'red', 240.0)
	add_zig_zag(47.0, 58.0, 0.4, "big", 'blue', 240.0)

func build_minute_1_to_2() -> void:
	add_single(62.0, 0.35, "big", "mixed", 350.0)
	add_single(64.0, 0.65, "big", "mixed", 350.0)
	add_wall(68.0, "big", "mixed", 240.0)
	add_wall(73.0, "big", "mixed", 240.0)
	add_wall(78.0, "big", "mixed", 250.0)
	add_stream(84.0, 95.0, 0.4, 0.25, "big", "mixed", 260.0)
	add_stream(84.0, 95.0, 0.4, 0.75, "big", "mixed", 260.0)
	add_zig_zag(100.0, 118.0, 0.4, "big", "mixed", 280.0)

func build_minute_2_to_3() -> void:
	add_choke_point_wall(124.0, 4, "red", 280.0)
	add_choke_point_wall(128.0, 0, "blue", 280.0)
	add_choke_point_wall(132.0, 2, "mixed", 300.0)
	add_stream(136.0, 148.0, 0.5, 0.15, "big", "none", 250.0) 
	add_stream(136.0, 148.0, 0.5, 0.85, "big", "none", 250.0) 
	add_contained_zig_zag(138.0, 147.0, 0.4, 0.32, 0.68, "big", "mixed", 300.0) 
	add_choke_point_wall(155.0, 2, "blue", 320.0) 
	add_choke_point_wall(158.0, 1, "red", 320.0)  
	add_choke_point_wall(161.0, 3, "blue", 320.0) 

func build_minute_3_to_4() -> void:
	add_stream(166.0, 190.0, 0.3, 0.85, "big", "none", 280.0)
	add_stream(166.0, 190.0, 0.3, 0.15, "big", "none", 280.0)
	add_stream(170.0, 190.0, 0.3, 0.32, "big", "none", 330.0)  
	add_stream(170.0, 190.0, 0.3, 0.68, "big", "none", 330.0)

	# Center spawns accelerating in frequency (decreasing delay) and velocity
	add_single(171.0, 0.50, "big", "blue", 300.0) # +3.0s delay
	add_single(174.0, 0.50, "big", "red", 300.0)  # +2.6s delay
	add_single(176.6, 0.50, "big", "blue", 310.0) # +2.2s delay
	add_single(178.8, 0.50, "big", "blue", 310.0) # +1.8s delay
	add_single(180.6, 0.50, "big", "red", 320.0)  # +1.5s delay
	add_single(182.1, 0.50, "big", "blue", 320.0) # +1.3s delay
	add_single(183.4, 0.50, "big", "red", 330.0)  # +1.2s delay
	add_single(184.4, 0.50, "big", "blue", 340.0) # Final high-speed rapid drops
	add_single(185.2, 0.50, "big", "red", 350.0)
	add_single(186.0, 0.50, "big", "blue", 360.0)
	add_single(186.8, 0.50, "big", "red", 350.0)
	add_single(187.4, 0.50, "big", "blue", 360.0)
	
	add_choke_point_wall(195.0, 0, "red", 340.0)
	add_choke_point_wall(198.0, 4, "blue", 340.0)
	add_choke_point_wall(201.0, 2, "red", 350.0)

func build_minute_4_to_5() -> void:
	# Converted from choke point walls to shootable mixed walls
	add_choke_point_wall(210.0, 0, "red", 360.0)
	add_choke_point_wall(211.0, 1, "blue", 360.0)
	add_choke_point_wall(212.0, 4, "blue", 360.0)
	add_choke_point_wall(213.0, 3, "red", 360.0)
	add_choke_point_wall(214.0, 2, "mixed", 360.0)
	
	# Hyper speed background hazard dash
	add_contained_zig_zag(220.0, 285.0, 0.3, 0.15, 0.85, "big", "mixed", 350.0) 
	
	# Converted climax gates to shootable mixed walls spaced at 1-second intervals
	add_wall(230.0, "big", "mixed", 380.0)
	add_wall(231.0, "big", "mixed", 380.0)
	add_wall(232.0, "big", "mixed", 380.0)
	add_wall(233.0, "big", "mixed", 380.0)
	add_wall(234.0, "big", "mixed", 380.0)
	
	# Searing center stream swapped to "none" polarity to act as an unkillable lane divider
	add_stream(245.0, 285.0, 0.2, 0.50, "big", "none", 400.0) 
	
	# Converted final rapid gates to shootable mixed walls flanking the center stream
	add_wall(250.0, "big", "mixed", 400.0)
	add_wall(252.0, "big", "mixed", 400.0)
	add_wall(254.0, "big", "mixed", 400.0)
	add_wall(256.0, "big", "mixed", 400.0)
	add_wall(258.0, "big", "mixed", 400.0)
	
	# Sustained onslaught: continuous walls spaced every 2 seconds to match the full stream runtime
	add_wall(260.0, "big", "mixed", 400.0)
	add_wall(262.0, "big", "mixed", 400.0)
	add_wall(264.0, "big", "mixed", 400.0)
	add_wall(266.0, "big", "mixed", 400.0)
	add_wall(268.0, "big", "mixed", 400.0)
	add_wall(270.0, "big", "mixed", 400.0)
	add_wall(272.0, "big", "mixed", 400.0)
	add_wall(274.0, "big", "mixed", 400.0)
	add_wall(276.0, "big", "mixed", 400.0)
	add_wall(278.0, "big", "mixed", 400.0)
	add_wall(280.0, "big", "mixed", 400.0)
	add_wall(282.0, "big", "mixed", 400.0)
	add_wall(284.0, "big", "mixed", 400.0)
	
	# Final threshold gate converted to a shootable red wall
	add_wall(295.0, "big", "red", 400.0)
	add_wall(295.2, "big", "blue", 400.0)
	

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
	if interval <= 0.0: return
	var current_time = start_time
	var counter = 0
	while current_time <= end_time:
		var final_polarity = get_alternating_polarity(counter, polarity)
		add_single(current_time, x_pct, tier, final_polarity, speed)
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
