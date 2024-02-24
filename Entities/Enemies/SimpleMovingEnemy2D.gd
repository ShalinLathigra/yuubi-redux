################################################################################
#
# Simplest Enemy for test purposes, will move forward pausing for (delay_beats)
# beats between each step. Step can be assigned in the editor or before the
# node is added to the tree, altering step afterwards will have no effect.
#
################################################################################

class_name SimpleMovingEnemy2D extends Enemy2D

@export var step: Vector2i
@export var delay_beats: int

# needs a method to decide the next step
# Enemies will create their own set of Actions in a list, then will iterate over that list
# i.e., move, wait, move, wait

func _ready() -> void:
	assert(Context.grid)
	actions.push_back(ActionFactory.BasicMove(self, Context.grid, step))
	for i in range(delay_beats):
		actions.push_back(Action.new())
	super._ready()
