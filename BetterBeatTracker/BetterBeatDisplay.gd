class_name BetterBeatDisplay
extends Node2D

@export var tick_sprite_default: PackedScene


var ms_to_reach_target: int
var ms_per_beat: int

var start_pos: Vector2
var target_pos: Vector2

var start_scale: Vector2
var target_scale: Vector2

var started: bool

func init(ticks: Array[Dictionary], ms_to_reach_target_in: int, ms_per_beat_in: int) -> void:

	ms_to_reach_target = ms_to_reach_target_in
	ms_per_beat = ms_per_beat_in

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
		new_sprite.self_modulate = BeatTracker.beat_color_map[ticks[i].beat_state]
		new_sprite.get_node(String(new_sprite.get_path()) + "/Label").text = "%d" % i

		ticks[i].sprite = new_sprite

# This is where the bulk of the work is done.
func update(ticks: Array[Dictionary]) -> void:
	if not started:
		return
	var time = Time.get_ticks_msec()

	for tick in ticks:
		if tick.beat_state in BeatTracker.beat_type_map.keys():
			tick.sprite.self_modulate = BeatTracker.beat_color_map[tick.beat_state]
		var t = float(time - tick.start_time) / ms_to_reach_target

		tick.sprite.position = target_pos * t + start_pos * (1.0 - t)

		if t < 0.0:
			tick.sprite.modulate.a = max(t, 0)
		elif t < 1.0:
			tick.sprite.scale = target_scale * t + start_scale * (1.0 - t)
			if t <= 0.25:
				tick.sprite.modulate.a = 4.0 * t
		elif t < 1.25:
			tick.sprite.modulate.a = 5.0 - 4.0 * t
		else:
			tick.sprite.modulate.a = 0.0

func generate_color() -> Color:
	return Color(randf(), randf(), randf())
