extends Node3D

func _ready() -> void:
	MapManager.map = $GridMap as GridMap
	$EntityManager.init_grid_locations()
