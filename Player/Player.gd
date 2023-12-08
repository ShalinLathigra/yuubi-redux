class_name Entity
extends AnimatedSprite3D

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var tween: Tween
var target_position: Vector3
var step_dist := Vector3(0,0,1.28)

var grid_position: Vector3i
var last_grid_position: Vector3i

var locked := false

var components: Array[Component]

func _ready() -> void:
	target_position = position
	play("Idle")
	for child in get_children():
		if child is Component:
			components.push_back(child)
			child.body = self
			child.init()

func do_beat_update() -> void:
	for component in components:
		if component.has_method("do_beat_update"):
			component.do_beat_update()
