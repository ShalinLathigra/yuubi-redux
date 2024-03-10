class_name ActionFactory
################################################################################
#
# Implementation of the Factory Pattern, contains helper methods for creating
# actions used by the player or general entities. This is expected to grow, may
# in future be split up into player/general actions or something.
# This is meant to simplify the creation of actions for the main game.
#
################################################################################

# PLAYER ACTIONS
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
			, Helpers.snap_to_entity_and_enable.bind( rock, player, grid )\
			, func(): rock.live = false)

static func PlayerFetch(player: Entity2D\
		, rock: Entity2D\
		, grid: Grid) -> Action:
	return FetchAction.new(rock\
			, player\
			, grid)

# GENERAL ACTIONS
static func BasicMove(subject: Entity2D\
		, grid: Grid\
		, displacement: Vector2i\
		, validity_checker: Callable=Callable(func(): return true)) -> Action:
	return MoveAction.new(subject\
			, grid\
			, displacement, validity_checker)

static func BasicRest() -> Action:
	return Action.new(func(): return true)

static func BatchRest(count: int) -> Array[Action]:
	var ret: Array[Action] = []
	for i in count:
		ret.append(Action.new(func(): return true))
	return ret
