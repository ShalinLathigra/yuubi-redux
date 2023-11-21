class_name Entity
extends AnimatedSprite3D

# subscribes to messages from the InputBroadcaster to set this action's beat
# perfect player input message will trigger the event instantly
var tween: Tween
var target_position: Vector3
var step_dist := Vector3(0,0,1.28)
var hop_height := 1.25
var steps_taken := 0

var grid_position: Vector3i

var locked := false

func _ready() -> void:
	target_position = position
	play("Idle")
