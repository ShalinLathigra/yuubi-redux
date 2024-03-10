################################################################################
#
# One off node, part of the "level". This is responsible for displaying progress
# towards enabling powers and when they are on.
#
# At this point it is pretty simple, just pulls images from the power manager
#
################################################################################

extends Control

var last_funk: int
var frets: Array[PowerFret]
var meter: Panel
var tween: Tween
@export var off_color: Color
@export var on_color: Color
@export var fret_scene: PackedScene

func _ready() -> void:
	Context.funk_changed.connect(handle_funk_changed)
	meter = $Meter as Panel

	var window_size = get_window().size
	for i in range(FunkTracker.max_funk):
		# What are the dimensions of the viewport?
		var new_fret: PowerFret = fret_scene.instantiate() as PowerFret
		new_fret.position.x = lerp(0, window_size.x\
				, i / float(FunkTracker.max_funk - 1)\
				) - new_fret.size.x * 0.5
		$Frets.add_child(new_fret)
		frets.push_back(new_fret)
	init_display()

func init_display() -> void:
	for fret in frets:
		fret.textureRect.visible = false
	for power in PowerManager.powers:
		if power.funk_threshold > len(frets):
			continue
		frets[power.funk_threshold].textureRect.texture = power.get_texture()
		frets[power.funk_threshold].textureRect.visible = true

func handle_funk_changed(funk: int, t: float) -> void:
	if tween:
		tween.stop()
	tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

	var width: int
	if (funk < len(frets) - 1):
		width = lerp(frets[funk].position.x + 4\
				, frets[funk + 1].position.x + 4\
				, t)
	else:
		width = frets[len(frets) - 1].possition.x + 4

	# update_colors
	for i in range(len(frets)):
		if i > len(frets) - 1:
			break
		frets[i].modulate = Color(off_color) if funk < i else Color(on_color)

	tween.tween_property(meter, "size:x", width, 0.3)
