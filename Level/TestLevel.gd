################################################################################
#
# Testing Ground. A lot of code here is tightly coupled to the specific Scene
# layout it was created for, before this is finished it must be broken down
# into components for handling i.e.:
# 	- Player Input queueing on beat
#	- Triggering effects in response to combo
#	- Enemy/Entity scripted movement
#	- Collisions
#	- Spawning enemies
#
################################################################################

extends Node2D

@export var dbg: bool

var grid: Grid
var player: Player2D
var rock: Entity2D

var enemies: Array[Enemy2D]
var actions: Array[Action]

var elapsed_beats: int
var started: bool

func _ready() -> void:
	Context.on_valid_beat.connect(handle_input)
	Context.on_game_beat.connect(handle_game_beat)

	grid = $TileMap as Grid
	player = $Player as Player2D
	rock = $Rock as Entity2D

	Context.grid = grid

	var node_arr: Array[Node] = get_tree().get_nodes_in_group("Entity")
	for node in node_arr:
		if not node is Entity2D: continue
		node.grid_pos = grid.local_to_map(node.position)
		node.position = grid.map_to_local(node.grid_pos)

	player.grid_pos = Vector2i(0,1)
	player.position = grid.map_to_local(player.grid_pos)

func handle_input(input: String, _time: int, _is_good: bool):
	var new_action: Action
	#if dbg: prints(Time.get_ticks_msec(), name, input, ":", time, "-", is_good)
	if input in ["UP", "DOWN"]:
		var displacement := Vector2i(0, -1 if input == "UP" else 1)
		new_action = ActionFactory.PlayerMove(player, rock, grid, displacement)
	elif input == "THROW":
		new_action = ActionFactory.PlayerThrow(player, rock, grid)
	elif input == "FETCH":
		new_action = ActionFactory.PlayerFetch(player, rock, grid)
	elif input == "BEAT":
		new_action = ActionFactory.BasicRest()
		# Do the effects that should take place during this dead time here
		# Maybe have a running tally at the end of how many of these were
		# done?
	if not new_action:
		return
	if len(actions) < 2:
		actions.push_back(new_action)
	else:
		remove_child(actions[1])
		actions[1] = new_action
	add_child(new_action)
	#print(actions)
	if not started:
		$BackgroundAudioPlayer.play(0)
		started = true

func _process(_delta: float) -> void:
	if len(actions) > 0:
		if not actions[0].is_started:
			for action in actions:
				if action.is_valid():
					action.enter()
					return
				actions.pop_front()
			if len(actions) <= 0: return
		actions[0].do()
		if actions[0].is_finished:
			actions.pop_front()

	var slain_enemies = 0
	var collision = false
	for enemy in enemies:
		if rock.is_running() && rock.live && enemy.position.distance_squared_to(rock.position) <= pow(64, 2):
			collision = true
			slain_enemies += 1
			remove_enemy(enemy)
		enemy.do()
	if collision:
		var old_action = actions[0]
		rock.tween.stop()
		rock.grid_pos.x = grid.local_to_map(rock.position).x
		old_action.call_deferred("queue_free")
		if rock.grid_pos.x > 1:
			actions[0] = ActionFactory.BasicMove(rock\
				, grid\
				, Vector2i.LEFT)
		else:
			actions[0] = ActionFactory.PlayerFetch(player, rock, grid)
	Context.enemy_popped.emit(slain_enemies)

func handle_game_beat() -> void:
	if not started: return
	for enemy in enemies:
		#grid.move_along_grid(enemy)
		enemy.handle_game_beat()
	# So, how is this part supposed to work?
	# 5 lanes is too many to just throw shit in. Need to
	if elapsed_beats % 18 == 0:
		add_enemy(create_juking_enemy(Vector2i(randi_range(12, 14), randi_range(2, 4))))
	elif elapsed_beats % 12 == 0:
		add_enemy(create_staggered_enemy(Vector2i(randi_range(12, 14), randi_range(2, 5))))
	elif elapsed_beats % 6 == 0:
		add_enemy(create_basic_enemy(Vector2i(randi_range(12, 14), randi_range(1, 5))))
	elapsed_beats += 1

func remove_enemy(enemy: Enemy2D):
	enemies.remove_at(enemies.find(enemy))
	enemy.tween.stop()
	enemy.call_deferred("queue_free")

func add_enemy(enemy: Enemy2D):
	enemies.push_back(enemy)
	add_child(enemy)

func create_basic_enemy(grid_pos: Vector2i) -> Enemy2D:
	return Enemy2DBuilder.new(grid, grid_pos)\
			.add_rest(2)\
			.add_move(Vector2i.LEFT)\
			.build()

func create_staggered_enemy(grid_pos: Vector2i) -> Enemy2D:
	return Enemy2DBuilder.new(grid, grid_pos)\
			.add_rest(3)\
			.add_move(Vector2i.UP + Vector2i.LEFT)\
			.add_rest()\
			.add_move(Vector2i.DOWN + Vector2i.LEFT)\
			.build()

func create_juking_enemy(grid_pos: Vector2i) -> Enemy2D:
	return Enemy2DBuilder.new(grid, grid_pos)\
			.add_rest()\
			.add_move(Vector2i.LEFT)\
			.add_rest()\
			.add_move(Vector2i.LEFT)\
			.add_move(Vector2i.DOWN)\
			.add_rest()\
			.add_move(Vector2i.LEFT)\
			.add_rest()\
			.add_move(Vector2i.LEFT)\
			.add_move(Vector2i.UP)\
			.build()
