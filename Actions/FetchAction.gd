################################################################################
#
# Subclass of action, more or less the workhorse of the game at this point.
# A MoveAction describes some "subject" moving "displacement" units along a "grid".
#
# Used by enemies and player alike to handle almost all motion.
# Finishes once the tween is done running, or if the tween is deleted.
#
################################################################################

class_name FetchAction extends Action

var subject: Entity2D
var ref_entity: Entity2D
var grid: Grid

func _init(s: Entity2D, r: Entity2D, g: Grid,\
			vc: Callable=Callable(func(): return),\
			se: Callable=Callable(func(): return),\
			fe: Callable=Callable(func(): return)) -> void:
	super._init(vc, se, fe)
	subject = s
	ref_entity = r
	grid = g

func enter() -> void:
	super.enter()
	grid.move_along_grid(subject, ref_entity.grid_pos - subject.grid_pos)

func do() -> void:
	if not subject.tween or not subject.tween.is_running():
		exit()

func exit() -> void:
	subject.tween.stop()
	subject.visible = false
	super.exit()

func is_valid() -> bool:
	return subject.visible == true && subject.grid_pos.y == ref_entity.grid_pos.y

func _to_string() -> String:
	return "Fetch: {subject} to {reference}".format({"subject": subject.name, "reference": ref_entity.name})
