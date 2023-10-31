class_name BetterBeatDisplay
extends Node2D

@export var tick_sprite_default: PackedScene
@export_color_no_alpha var base_color := Color.DIM_GRAY
@export_color_no_alpha var missed_color := Color.BLACK
@export_color_no_alpha var good_color := Color.YELLOW
@export_color_no_alpha var perfect_color := Color.SEA_GREEN

var num_ticks: int
var ms_to_reach_target: int
var ms_per_beat: int

var start_pos: Vector2
var target_pos: Vector2

var start_scale: Vector2
var target_scale: Vector2

var ticks: Array[Dictionary]
var tick_index : int

var started_beats: int # Used to track where the next beat should be instantiated

var started: bool

func init() -> void:
	var start_obj := ($StartPoint as Sprite2D)
	var target_obj := ($EndPoint as Sprite2D)

	start_pos = start_obj.position
	target_pos = target_obj.position
	start_scale = start_obj.scale
	target_scale = target_obj.scale

	# Instantiate all ticks
	for i in range(int(ms_to_reach_target / ms_per_beat * 1.5)):
		var new_sprite = tick_sprite_default.instantiate() as Sprite2D;
		add_child(new_sprite)
		new_sprite.position = start_obj.position
		new_sprite.scale = start_obj.scale
		new_sprite.self_modulate = base_color

		# Save ref to data for later
		var data = {
			"sprite": new_sprite,
			"start_time": ms_per_beat * i,
			"index": i,
			"name": "%d" % i,
			"active": true
		}
		ticks.push_back(data)

		started_beats = ticks.size()

# This is where the bulk of the work is done.
func _process(_delta: float) -> void:
	if not started:
		return
	var time = Time.get_ticks_msec()

	for tick in ticks:
		var t = float(time - tick.start_time) / ms_to_reach_target

		tick.sprite.position = target_pos * t + start_pos * (1.0 - t)

		if t < 0.0:
			tick.sprite.modulate.a = max(t, 0)
		elif t < 1.0:
			tick.sprite.scale = target_scale * t + start_scale * (1.0 - t)
			if t <= 0.25:
				tick.sprite.modulate.a = 4.0 * t
		elif t < 1.25:
			if tick.active:
				tick.sprite.self_modulate = missed_color
				tick.active = false
				tick_index = (tick_index + 1) % ticks.size()
			tick.sprite.modulate.a = 5.0 - 4.0 * t
		else:
			tick.sprite.self_modulate = base_color
			tick.sprite.modulate.a = 0.0
			tick.start_time = ms_per_beat * started_beats
			tick.active = true
			started_beats += 1

# TODO: Update beat tracker
# When a button is pressed, we need to know the n-1th beat that's going on.
# current beat should always be:
# When the beat is triggered and is good, look at the current beat. See if it's ACTUALLY good or not.

func generate_color() -> Color:
	return Color(randf(), randf(), randf())
