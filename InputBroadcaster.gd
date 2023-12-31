extends Node

signal input_on_beat(input_data: Dictionary)

# inputs trigger animations. This is released when anims finish.
var input_blocked: bool

func _process(_delta: float) -> void:
	if input_blocked:
		return
	var time:= Time.get_ticks_msec()
	var inputs = ["W", "A", "S", "D"]
	for input in inputs:
		if Input.is_action_just_pressed(input):
			broadcast_input_on_beat(input, time)
			break

# TODO: Will this need to handle having multiple ticks happening all at the same time?
# TODO: Maybe ticks need to be aware of when they're ticked. If a tick is already in a state, flag it.
# TODO: Allow get_beat to return false. Not always going to receive a beat.

# How do other rhythm games handle this?

# add an option to beat tracker to reflect whether the last beat was triggered or not
# Now then, I can press a number and find out if it's at the right time.
func broadcast_input_on_beat(input: String, time: int) -> void:
	input_blocked = true
	var beat_state = BeatTracker.get_beat(time)
	input_on_beat.emit({"input": input, "beat_state": beat_state, "time": time})
	input_blocked = false
