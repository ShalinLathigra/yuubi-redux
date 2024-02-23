extends CanvasLayer

signal on_valid_beat(input: String, time: int, is_good: bool)
signal on_game_beat()

@export var dbg: bool
@export var stats: GameBeatInfo
@export var bounds: RectangleShape2D
@export var display_offset: Vector2

var num_beats: int
var ms_per_beat: int
var time_trackers: Array[float]
var beat_width_percentage: float
var converted_rate: float

var labels: Array[Label]

var time_of_last_beat: int

var display: Node2D
var animation_player: AnimationPlayer

var start_time_msecs: int
var started: bool

func _ready() -> void:
	InputReceiver.on_input.connect(handle_input)

	animation_player = $AnimationPlayer as AnimationPlayer

	num_beats = int(stats.beats_per_minute / 60 * (stats.time_to_sweet_spot * 2.0))
	ms_per_beat = int(60000.0 / stats.beats_per_minute)

	for i in range(num_beats):
		time_trackers.push_back(0.0)
		var new_label = Label.new()
		add_child(new_label)
		new_label.global_position.x = 64
		new_label.global_position.y = 196 + 24 * i
		labels.push_back(new_label)

	converted_rate = bounds.size.x / (stats.time_to_sweet_spot * 1000.0)
	# looking for the ration of beat width vs bounds size
	# time = distance / speed
	beat_width_percentage = (stats.beat_width / (stats.time_to_sweet_spot * 1000.0)) * 0.5

	# Initialize the AI beat timer
	var beat_timer = create_tween().set_loops()
	beat_timer.tween_interval(ms_per_beat / 1000.0)
	beat_timer.tween_callback(
		func():
			#prints("Emitting Timer Event")
			on_game_beat.emit())

	# initialize display params
	display = $Display as Node2D
	display.inject_data(num_beats, converted_rate, display_offset, bounds, stats, time_trackers, dbg)

func handle_input(input: StringName, input_time: int):
	if not started:
		started = true
		start_time_msecs = Time.get_ticks_msec()
		$AudioStreamPlayer.play()

	if dbg: prints(input, ":", input_time)
	var t = 0.5
	var is_good = false
	for i in range(num_beats):
		var time = time_trackers[i]
		if dbg: labels[i].text = "%f %f %f %f" % [time - beat_width_percentage, time, t, time + beat_width_percentage]
		else: labels[i].text = ""
		if t < time - beat_width_percentage:
			if dbg: labels[i].self_modulate = Color.RED
			continue
		elif time + beat_width_percentage < t:
			if dbg: labels[i].self_modulate = Color.RED
			continue
		if dbg:
			labels[i].self_modulate = Color.GREEN
			prints(Time.get_time_string_from_system(), name, "Found good beat:", i)
		is_good = true

	# Emit Beat when ready!
	on_valid_beat.emit(input, input_time, is_good)
	animation_player.stop()
	animation_player.play("good_beat" if is_good else "bad_beat")
	time_of_last_beat = input_time

func _process(_delta: float) -> void:
	# Calculate Beat Offsets:
	if not started:
		return
	var elapsed_time = Time.get_ticks_msec() - start_time_msecs
	for beat in range(num_beats):
		# Determine the modulated time
		var time_offset = ms_per_beat * beat
		var modulo_time = (elapsed_time + time_offset) % (ms_per_beat * num_beats)
		# How far through move animation are you?
		var t = float(modulo_time) / (ms_per_beat * num_beats)
		# position is modified by t
		time_trackers[beat] = t
	display.queue_redraw()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_OFFSET_UP"):
		stats.display_offset += 12.5
		if dbg: prints("Adjusted Offset:", stats.display_offset)
	if event.is_action_pressed("DEBUG_OFFSET_DOWN"):
		stats.display_offset -= 12.5
		if dbg: prints("Adjusted Offset:", stats.display_offset)
	if event.is_action_pressed("DEBUG_TOGGLE"):
		dbg = not dbg
		display.dbg = dbg
		prints("Toggled Debug:", "ON" if dbg else "OFF")

"""
Adventure/Kick into warp drive
Combat/
	Break through the lines
	Field Battle?

"""
