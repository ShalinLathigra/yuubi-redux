################################################################################
#
# An Entity2D is effectively a point in space that lives in a grid and is animated
# using the associated tween. The state of the tween (is running) can be used as
# a simple state check until a state machine is incorporated.
#
# The live boolean is only currently assigned for the "rock", by the "testlevel"
# for handling collisions.
#
################################################################################

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
