class_name ActionFactory

static func PlayerMove(player: Entity2D\
		, rock: Entity2D\
		, grid: Grid\
		, displacement: Vector2i) -> Action:
	return MoveAction.new(player\
			, grid\
			, displacement\
			, func(): return rock.visible == false)

static func PlayerThrow(player: Entity2D\
		, rock: Entity2D\
		, grid: Grid) -> Action:
	return MoveAction.new(rock\
			, grid\
			, Vector2i.RIGHT * 4\
			, func(): return rock.visible == false\
					&& player.is_running() == false\
			, Helpers.snap_to_entity_and_enable.bind( rock, player, grid ))

static func PlayerFetch(player: Entity2D\
		, rock: Entity2D\
		, grid: Grid) -> Action:
	return MoveAction.new(rock\
			, grid\
			, Vector2i.RIGHT * -4\
			, func(): return rock.visible == true\
			, func(): return\
			, func(): rock.visible = false)

static func BasicMove(subject: Entity2D\
		, grid: Grid\
		, displacement: Vector2i) -> Action:
	return MoveAction.new(subject\
			, grid\
			, displacement)

static func BasicRest() -> Action:
	return Action.new()

static func BatchRest(subject: Entity2D, count: int) -> Array[Action]:
	var ret: Array[Action] = []
	for i in count:
		ret.append(Action.new())
	return ret

static func EnemyActionsFromSequence(subject: Entity2D\
		, grid: Grid\
		, sequence: Array) -> Array[Action]:
	var ret: Array[Action] = []
	for action in sequence:
		match action["action"]:
			"Rest": ret.append_array(BatchRest(subject, action["data"] as int))
			"Move": ret.append(BasicMove(subject, grid, Vector2i(action["data"]["x"] as int, action["data"]["y"] as int)))
		print(ret)
	return ret
