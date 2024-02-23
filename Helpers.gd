class_name Helpers

static func snap_to_entity_and_enable(subject: Entity2D, reference: Entity2D, grid: Grid) -> void:
	subject.grid_pos = reference.grid_pos
	subject.visible = true
	subject.position = grid.map_to_local(subject.grid_pos)

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
