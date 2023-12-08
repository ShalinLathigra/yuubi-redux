class_name EnemyMover
extends Component

@export var units_per_beat: int = 1
@export var is_moving_right: bool = false
@export var hop_height: float = .25
@export var beat_duration_ratio: float = .5
# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var tween: Tween
var target_position: Vector3

func init() -> void:
	target_position = body.position

func do_beat_update() -> void:
	# Decide direction
	# Use hop_one_tile method from entityManager
	var grid_offset = (Vector3i.RIGHT if is_moving_right else Vector3i.LEFT) * units_per_beat
	await EntityManager.hop_body_to_offset(body, grid_offset, hop_height, beat_duration_ratio)

