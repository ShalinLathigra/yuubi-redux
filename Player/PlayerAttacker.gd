extends Node3D

@export var body: Entity

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var target_position: Vector3

func _ready() -> void:
	InputBroadcaster.input_on_beat.connect(handle_input_beat)

func handle_input_beat(input_data: Dictionary) -> void:
	# if input_data is of attack related type, do that input
	if body.locked:
		print("Can't Attack Here!")
		return
	if input_data.input == "A":
		try_fire(input_data)
	if input_data.input == "D":
		try_retrieve(input_data)

func try_fire(input_data: Dictionary) -> void:
	body.locked = true
	print("Start Retrieving")
	await get_tree().create_timer(0.25).timeout
	print("Done Retrieving")
	body.locked = false

func try_retrieve(input_data: Dictionary) -> void:
	body.locked = true
	print("Start Attacking")
	await get_tree().create_timer(0.25).timeout
	print("Done Attacking")
	body.locked = false
