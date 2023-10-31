extends CanvasLayer

@export_range(1, 24) var num_ticks: int
@export_range(0, 5000, 100) var ms_to_reach_target: int
@export_range(0, 1000, 50) var ms_per_beat: int

var beat_display: BetterBeatDisplay

enum BeatState {
	PERFECT,
	GOOD,
	BAD
}

var beat_type_map := {
	BeatState.PERFECT: { "text": "Perfect", "threshold": 0.4 },
	BeatState.GOOD: { "text": "Good", "threshold": 0.6 },
	BeatState.BAD: { "text": "Bad", "threshold": 1 }
}

func _ready() -> void:
	beat_display = $BetterBeatDisplay as BetterBeatDisplay
	assert(beat_display)
	beat_display.num_ticks = num_ticks
	beat_display.ms_to_reach_target = ms_to_reach_target
	beat_display.ms_per_beat = ms_per_beat
	beat_display.init()
	beat_display.started = true

# This only needs to be used by the player. Timing here is based on the half
# 	beats
func get_beat(target_ms: int):
	var current_beat = beat_display.ticks[beat_display.tick_index]
	var delta = abs(target_ms - current_beat.start_time)
	prints(current_beat, target_ms, delta)
