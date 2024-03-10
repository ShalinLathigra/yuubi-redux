################################################################################
#
# Convenience class to differentiate the player. At time of writing this the
# Player object's only responsibility is being manipulated by actions triggered
# in TestLevel.gd
#
################################################################################

class_name Player2D extends Entity2D

var actions: Array[Action]
var current_action: int

func _ready() -> void:
	Context.on_processed_beat.connect(handle_action)
	super._ready()
	for action in actions:
		add_child(action)

func handle_action(input: int, _time: int, _is_good: bool, input_action: Action):
	var new_action: Action = input_action
	#if dbg: prints(Time.get_ticks_msec(), name, input, ":", time, "-", is_good)
	var needs_fetch = Context.rock.visible == true
	for action in actions:
		if action is FetchAction:
			needs_fetch = false
	if needs_fetch:
		new_action = ActionFactory.PlayerFetch(self, Context.rock, Context.grid)

	if len(actions) < 2:
		actions.push_back(new_action)
	else:
		remove_child(actions[1])
		actions[1] = new_action
	add_child(new_action)
	#if dbg: prints(Time.get_ticks_msec(), name, "actions:", actions)

func do() -> void:
	if len(actions) > 0:
		if not actions[0].is_started:
			for action in actions:
				if action.is_valid():
					action.enter()
					return
				actions.pop_front().call_deferred("queue_free")
			if len(actions) <= 0: return
		actions[0].do()
		if actions[0].is_finished:
			actions.pop_front().call_deferred("queue_free")

func handle_rock_collision() -> void:
	actions[0].abort()
	Context.rock.grid_pos.x = Context.grid.local_to_map(Context.rock.position).x
	# If next action is a fetch, then do nothing
	if len(actions) > 1 and actions[1] is FetchAction:
		return
	# otherwise, do we need to bounce to ground?
	if Context.rock.grid_pos.x > 1:
		actions.push_front(ActionFactory.BasicMove(Context.rock\
			, Context.grid\
			, Vector2i.LEFT))
	# or jam in a quick little fetch
	else:
		actions.push_front(ActionFactory.PlayerFetch(self, Context.rock, Context.grid))
