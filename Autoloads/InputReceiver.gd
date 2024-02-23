extends Node

signal on_input(input, time)

func _process(_delta: float) -> void:
	var time:= Time.get_ticks_msec()
	var inputs = ["UP", "DOWN", "THROW", "FETCH", "BEAT"]
	for input in inputs:
		if Input.is_action_just_pressed(input):
			#prints("received input event", input)
			on_input.emit(input, time)
			break
