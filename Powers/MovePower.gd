################################################################################
#
# Power affecting the Move action. Contains the name, activation threshold, and
# icon Methods should be overridden if needed.
#
################################################################################

class_name MovePower extends Power
var type: ActionRef.Type
var displacement_boost: Vector2i

func _init(t: ActionRef.Type, boost: Vector2i, tex_path: StringName, f: int) -> void:
	type = t
	displacement_boost = boost
	super._init("Throw Power", tex_path, f)

func invoke(action: MoveAction) -> void:
	action.displacement += displacement_boost
