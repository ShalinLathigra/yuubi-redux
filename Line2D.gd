@tool
extends Line2D

@export var start_point: Sprite2D
@export var end_point: Sprite2D

func _process(_delta: float) -> void:
	if Engine.is_editor_hint():
		points[0] = start_point.position
		points[1] = end_point.position
