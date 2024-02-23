class_name Entity2D extends Node2D

var grid_pos: Vector2i
var tween: Tween
var live: bool

func _ready() -> void:
	if not get_parent().is_node_ready():
		await get_parent().ready
	assert(Context.grid)
	Context.grid.center_entity(self)

func is_running() -> bool:
	return tween && tween.is_running()
