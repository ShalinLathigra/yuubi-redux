extends TextureRect

var mat: ShaderMaterial
var tween: Tween
var last_label: Label
var current_label: Label
var next_label: Label
#
#var beat_to_color_map: Dictionary = {
				#BeatTracker.BeatState.PERFECT: Color.WEB_GREEN ,
				#BeatTracker.BeatState.GOOD: Color.GOLD ,
				#BeatTracker.BeatState.BAD: Color.DARK_RED
#}
#var base_color = Color(0.25,0.25,0.25,1)
#
#func _ready() -> void:
	#mat = material as ShaderMaterial
	#last_label = $LastBeatLabel as Label
	#current_label = $CurrentLabel as Label
	#next_label = $NextBeatLabel as Label
#
	#InputBroadcaster.input_on_beat.connect(handlePlayerInput)
#
#func _process(_delta: float) -> void:
	#var t = (Time.get_ticks_msec() % BeatTracker.ms_per_beat) / float(BeatTracker.ms_per_beat)
	#mat.set_shader_parameter("t", easeOutQuadratic(t))
	##mat.set_shader_parameter("t", t)
#
	#next_label.text = "Next: %d" % (BeatTracker.time_of_last_beat + BeatTracker.ms_per_beat)
	#current_label.text = "Now: %d" % (Time.get_ticks_msec()/100 * 100)
	#last_label.text = "Last: %d" % (BeatTracker.time_of_last_beat)
#
#func handlePlayerInput(input_data: Dictionary) -> void:
	#if tween:
		#tween.stop()
	#tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_QUAD).set_parallel(true)
	#tween.tween_property(current_label, "self_modulate", beat_to_color_map[input_data.beat_state], 0.25)
	#tween.tween_property(current_label, "scale", Vector2.ONE * 2, 0.125)
	#tween.chain().tween_property(current_label, "self_modulate", Color.WHITE, 0.125)
	#tween.tween_property(current_label, "scale", Vector2.ONE, 0.1)
#
#func easeInOutCubic(x: float) -> float:
	#if x < 0.5:
		#return 4 * pow(x, 3)
	#return 1 - pow(-2 * x + 2, 3) / 2;
#
#func easeOutQuadratic(x: float) -> float:
	#return 1 - (1 - x) * (1 - x);
