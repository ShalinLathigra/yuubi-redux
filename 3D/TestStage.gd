extends Node3D

func _ready() -> void:
	MapManager.map = $GridMap as GridMaps
	EntityManager.reseat_entities()
	EntityManager.player = get_tree().get_first_node_in_group("Player")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("DEBUG_RESET"):
		get_tree().reload_current_scene()
