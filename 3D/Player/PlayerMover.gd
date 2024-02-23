extends Component

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var tween: Tween
var target_position: Vector3

@export var hop_height: float = 1.25
@export var beat_duration_ratio: float = 0.25

func init() -> void:
	target_position = body.position
	InputBroadcaster.input_on_beat.connect(handle_input_beat)

func handle_input_beat(input_data: Dictionary) -> void:
	if not body.locked and input_data.input in ["W", "S"]:
		move_by_input(input_data)

func move_by_input(input_data: Dictionary) -> void:
	body.locked = true
	body.play("Move")
	var grid_offset := Vector3i.ZERO
	match input_data.input:
		"W":
			grid_offset = Vector3i.FORWARD
		"S":
			grid_offset = Vector3i.BACK

	await EntityManager.hop_body_to_offset(body, grid_offset, hop_height, beat_duration_ratio)
	body.play("Idle")
	body.locked = false
