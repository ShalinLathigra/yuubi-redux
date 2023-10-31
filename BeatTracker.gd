extends Control

signal beat
signal half_beat

enum BeatState {
	PERFECT,
	GOOD,
	BAD
}

var beat_type_map := { \
				BeatState.PERFECT: { "text": "Perfect", "threshold": 0.4 }, \
				BeatState.GOOD: { "text": "Good", "threshold": 0.6 }, \
				BeatState.BAD: { "text": "Bad", "threshold": 1 }
				}

var ms_per_beat: int = 500
var time_of_last_beat: int

func _process(_delta: float) -> void:
	var elapsed_ms = Time.get_ticks_msec()
	if (elapsed_ms >= time_of_last_beat + ms_per_beat):
		time_of_last_beat = elapsed_ms
		beat.emit()

# This only needs to be used by the player. Timing here is based on the half
# 	beats
func get_beat(target_ms: int) -> BeatState:
	var nearest_beat : int = ceil(target_ms / float(ms_per_beat)) * ms_per_beat
	var beat_delta = max(target_ms, nearest_beat) - min(target_ms, nearest_beat)
	for beat_type in beat_type_map:
		if beat_delta < ms_per_beat * beat_type_map[beat_type].threshold:
			return beat_type
	return BeatState.BAD
