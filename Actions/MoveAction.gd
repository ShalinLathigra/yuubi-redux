################################################################################
#
# Subclass of action, more or less the workhorse of the game at this point.
# A MoveAction describes some "subject" moving "displacement" units along a "grid".
#
# Used by enemies and player alike to handle almost all motion.
# Finishes once the tween is done running, or if the tween is deleted.
#
################################################################################

class_name MoveAction extends Action

var subject: Entity2D
var grid: Grid
var displacement: Vector2i

func _init(s: Entity2D, g: Grid, d: Vector2i,\
			vc: Callable=Callable(func(): return),\
			se: Callable=Callable(func(): return),\
			fe: Callable=Callable(func(): return)) -> void:
	super._init(vc, se, fe)
	subject = s
	grid = g
	displacement = d

func enter() -> void:
	super.enter()
	grid.move_along_grid(subject, displacement)

func do() -> void:
	if not subject.tween or not subject.tween.is_running():
		exit()

func _to_string() -> String:
	return "Move: {subject} by {displacement}".format({"subject": subject.name, "displacement": displacement})
