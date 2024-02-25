extends Sprite2D

func _ready() -> void:
	Context.on_game_beat.connect(
			func():
				var tw = create_tween()\
						.set_ease(Tween.EASE_OUT)\
						.set_parallel(false)\
						.set_trans(Tween.TRANS_QUAD)
				tw.tween_property(self, "scale", Vector2.ONE * 1.1, 0.1)
				tw.tween_property(self, "scale", Vector2.ONE, 0.2))
