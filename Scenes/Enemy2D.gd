class_name Enemy2D extends Entity2D

@export var sprite: Sprite2D
var actions: Array[Action]
var current_action: int

# needs a method to decide the next step
# Enemies will create their own set of Actions in a list, then will iterate over that list
# i.e., move, wait, move, wait


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

