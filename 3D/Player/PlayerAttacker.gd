extends Component

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var target_position: Vector3
var max_num_discus := 3

# TODO: make an array of size max_num_discus
@export var projectile_bag: ProjectileBag

# Do setup that must occur after parent is readied
func init() -> void:
	InputBroadcaster.input_on_beat.connect(handle_input_beat)
	print(body)
	projectile_bag.init(max_num_discus, body.position)

func handle_input_beat(input_data: Dictionary) -> void:
	if input_data.input == "D":
		try_fire(input_data)
	if input_data.input == "A":
		try_retrieve(input_data)

func try_fire(_input_data: Dictionary) -> void:
	if body.locked:
		print("Can't Attack While the body is locked!")
		return
	if not projectile_bag.has_projectile_free():
		print("Need to recover a projectile before throwing again!")
		return

	body.locked = true
	body.play("Throw")
	var ball = projectile_bag.get_projectile()
	ball.init(body.grid_position)
	EntityManager.add_entity(ball)
	await get_tree().create_timer(0.5).timeout
	# TODO: Add ability letting user run around even without any projectiles
	body.locked = not projectile_bag.has_projectile_free()
	body.play("FollowThrough" if body.locked else "Idle")

func try_retrieve(_input_data: Dictionary) -> void:
	print("triggering retrieve")
	body.locked = true
	body.play("Catch")
	var proj = projectile_bag.find_used_projectile_in_row(body.grid_position.z)
	EntityManager.remove_entity(proj)
	projectile_bag.return_projectile(proj)
	await get_tree().create_timer(0.5).timeout
	body.play("Idle")
	body.locked = false

# TODO: Figure out how this is supposed to work.
# Create a spear, moves on the half beat.
