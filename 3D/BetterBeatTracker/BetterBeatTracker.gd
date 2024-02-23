extends CanvasLayer

signal beat

enum BeatState {
	PERFECT,
	GOOD,
	BAD,
	BASE
}

var beat_type_map := {
	BeatState.PERFECT: { "text": "Perfect", "threshold_multiplier": 0.3 },
	BeatState.GOOD: { "text": "Good", "threshold_multiplier": 0.5 },
	BeatState.BAD: { "text": "Bad", "threshold_multiplier": 1 },
	BeatState.BASE: { "text": "BASE", "threshold_multiplier": -1 }
}
var beat_color_map := {
	BeatState.PERFECT: Color.SEA_GREEN ,
	BeatState.GOOD: Color.YELLOW ,
	BeatState.BAD: Color.DARK_RED ,
	BeatState.BASE: Color.BLACK
}

@export_range(0, 5000, 100) var ms_to_reach_target: int
@export_range(0, 1000, 50) var ms_per_beat: int

var ticks: Array[Dictionary]
var tick_index : int
var beat_display: BetterBeatDisplay
var started_beats: int # Used to track where the next beat should be instantiated
var seconds_per_beat: float

func _ready() -> void:
	# Instantiate all ticks
	seconds_per_beat = ms_per_beat / 1000.0
	for i in range(int(ms_to_reach_target / ms_per_beat * 1.5)):
		# Save ref to data for later
		var data = {
			"sprite": null,
			"start_time": ms_per_beat * i,
			"index": i,
			"name": "%d" % i,
			"moving_and_visible": true,
			"used": false,
			"beat_state":BeatState.BASE
		}
		ticks.push_back(data)
	started_beats = ticks.size()

	beat_display = $BetterBeatDisplay as BetterBeatDisplay
	assert(beat_display)
	beat_display.init(ticks, ms_to_reach_target, ms_per_beat)
	#print("created ticks: ", ticks)
	beat_display.started = true

# This is where the bulk of the work is done.
func _process(_delta: float) -> void:
	var time = Time.get_ticks_msec()

	for tick in ticks:
		var t = float(time - tick.start_time) / ms_to_reach_target

		if t < 1.0:
			continue
		elif t < 1.25:
			if tick.moving_and_visible:
				tick.moving_and_visible = false
				tick_index = (tick_index + 1) % ticks.size()
				beat.emit()
		elif not tick.moving_and_visible:
				tick.moving_and_visible = true
				tick.start_time = ms_per_beat * started_beats
				#prints("resetting beat:", tick.index, "now in state", beat_type_map[tick.beat_state], "and color", beat_color_map[tick.beat_state])
				tick.beat_state = BeatState.BASE
				tick.used = false
				started_beats += 1
	beat_display.update(ticks)

# This only needs to be used by the player. Timing here is based on the half
# 	beats
func get_beat(time: int):
	# Starting out looking at this beat, will always check this and the previous
	# beat to catch late-comers
	var ret = BeatState.BAD
	var current_beat = ticks[tick_index]

	if current_beat.used:
		return ret

	var delta = ms_to_reach_target - abs(time - current_beat.start_time)

	for beat_type in beat_type_map:
		var low_threshold = ms_per_beat * beat_type_map[beat_type].threshold_multiplier
		var high_threshold = ms_per_beat - low_threshold * 0.5
		if delta < low_threshold:
			ret = beat_type
			break
		if delta > high_threshold:
			current_beat = ticks[tick_index - 1 if tick_index > 0 else ticks.size() - 1]
			ret = beat_type
			break
	current_beat.beat_state = ret
	current_beat.used = true
	#prints("Handling beat:", current_beat.index, "is of state:", beat_type_map[current_beat.beat_state].text, "and color", beat_color_map[current_beat.beat_state])
	# Fire off selector animations here!
	return ret

## TODO: Figure out why this allows beats to be updated twice even through the "used" check
