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
	if not Context.is_ready:
		await Context.level_ready

	Context.grid.center_entity(self, true)

func is_running() -> bool:
	return tween && tween.is_running()
