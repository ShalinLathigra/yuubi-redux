################################################################################
#
# Helper methods I didn't have anywhere else to put. Not a good thing TBH.
#
################################################################################

class_name Helpers

# Used by the rock to snap to the player and enable.
# Should be converted into a method on rock.gd (also make the script)
static func snap_to_entity_and_enable(subject: Entity2D, ref: Entity2D, grid: Grid) -> void:
	subject.grid_pos = ref.grid_pos
	subject.visible = true
	grid.center_entity(subject)
	subject.live = true

# Used to parse JSON strings from ScriptedEnemy2D.gd
static func parse_action_json_to_sequence(name: String, json_string: String) -> Array:
	var json = JSON.new()
	var error = json.parse(json_string)
	assert(error == OK and typeof(json.data) == TYPE_ARRAY\
			, "error parsing action sequence: %s for %s" % [json_string, name])
	for element in json.data:
		if(typeof(element) != TYPE_DICTIONARY):
			print("error parsing dict: %s for %s" % [element, name])
			json.data.remove_at(json.data.find(element))
		if(element.get("action", null) == null\
				or element.get("data", null) == null):
			print("error parsing action and data: %s for %s" % [element, name])
			json.data.remove_at(json.data.find(element))
	return json.data

# HELPER METHOD FOR ENEMIES
static func EnemyActionsFromSequence(subject: Entity2D\
		, grid: Grid\
		, sequence: Array) -> Array[Action]:
	var ret: Array[Action] = []
	for action in sequence:
		match action["action"]:
			"Rest": ret.append_array(ActionFactory.BatchRest(action["data"] as int))
			"Move": ret.append(ActionFactory.BasicMove(subject\
					, grid\
					, Vector2i(action["data"]["x"] as int\
					, action["data"]["y"] as int)))
		print(ret)
	return ret
