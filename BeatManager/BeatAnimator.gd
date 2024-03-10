extends AnimationPlayer

func _ready() -> void:
	Context.on_input_beat.connect(handle_input_beat)

func handle_input_beat(input, input_time, is_good) -> void:
	stop()
	play("good_beat" if is_good else "bad_beat")
