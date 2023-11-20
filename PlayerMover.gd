extends Node

@export var body: AnimatedSprite3D

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var tween: Tween
var target_position: Vector3
var step_dist := Vector3(0,0,1.28)
var hop_height := 1.25
var steps_taken := 0

var grid_position: Vector3i

var can_move := true

func _ready() -> void:
	target_position = body.position
	body.play("Idle")

	InputBroadcaster.input_on_beat.connect(handle_input_beat)

func handle_input_beat(input_data: Dictionary) -> void:
	if can_move:
		move_by_input(input_data)

func move_by_input(input_data: Dictionary) -> void:
	can_move = false
	var grid_offset := Vector3i.ZERO
	match input_data.input:
		"W":
			grid_offset = Vector3i.FORWARD
		"S":
			grid_offset = Vector3i.BACK

	var last_target_position = target_position
	if MapManager.check_move_offset(grid_position, grid_offset):
		target_position = MapManager.map.map_to_local(grid_position + grid_offset)
		grid_position += grid_offset

	if tween:
		tween.stop()
	tween = create_tween().set_parallel()
	tween.tween_property(self, "position:z", target_position.z, 0.2).from(last_target_position.z)
	tween.tween_property(self, "position:y", hop_height, 0.1).from(last_target_position.y)
	tween.chain().tween_property(self, "position:y", target_position.y, 0.1).from(hop_height)

	await tween.finished
	can_move = true
