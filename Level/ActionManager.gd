extends Node

func _ready() -> void:
	Context.on_input_beat.connect(handle_input_beat)

func handle_input_beat(input: int, time: int, is_good: bool):
	var new_action: Action
	#if dbg: prints(Time.get_ticks_msec(), name, input, ":", time, "-", is_good)
	if input in [ActionRef.Type.UP, ActionRef.Type.DOWN]:
		var displacement := Vector2i(0, -1 if input == ActionRef.Type.UP else 1)
		new_action = ActionFactory.PlayerMove(Context.player, Context.rock, Context.grid, displacement)
	elif input == ActionRef.Type.THROW:
		new_action = ActionFactory.PlayerThrow(Context.player, Context.rock, Context.grid)
	elif input == ActionRef.Type.FETCH:
		new_action = ActionFactory.PlayerFetch(Context.player, Context.rock, Context.grid)
	elif input == ActionRef.Type.BEAT:
		new_action = ActionFactory.BasicRest()
	if not new_action:
		return
	# The action type is recorded now,
	PowerManager.process_action(input, new_action)
	Context.on_processed_beat.emit(input, time, is_good, new_action)
