################################################################################
#
# An Enemy2D is an Entity2D that contains a list of Actions (See the Command Pattern)
# to describe the behaviour. This is essentially a sprite with a position and
# some instructions. This class was is closely tied to the static "Enemy2DBuilder"
# object (See res://Entities/Enemies/Enemy2DBuilder.tscn) which allows enemies
# to be instantiated programatically, as well as the other Enemy2D sub-classes
# which use other methods to provide the intial action set.
#
# This, like other enemies, will step through all actions one at a time, looping
# when done.
#
# Can be hit because the example scene is in the "Hittable" group...
# Theoretically, this could be removed, applied when this is instantiated.
# This could turn in to "BuiltEntity2D" or something and become more general.
#
################################################################################

class_name Enemy2D extends Entity2D

@export var sprite: Sprite2D
var actions: Array[Action]
var current_action: int

func _ready() -> void:
	super._ready()
	for action in actions:
		add_child(action)

func handle_game_beat() -> void:
	if len(actions) <= 0: return
	#print("exiting state: ", actions[current_action])
	actions[current_action].exit()
	var next_action = (current_action + 1) % len(actions)
	actions[next_action].reset()
	current_action = next_action

func do() -> void:
	if len(actions) <= 0: return
	if not actions[current_action].is_started:
		#print("Entering state: ", actions[current_action])
		actions[current_action].enter()
		return
	actions[current_action].do()

