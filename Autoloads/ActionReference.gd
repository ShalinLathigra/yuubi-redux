extends Node

enum Type {
	UP,
	DOWN,
	THROW,
	FETCH,
	BEAT
}

static func get_type_string(input: int) -> StringName:
	return Type.keys()[input]
