extends Node

# Assign the map on level start
# Then player/entity manager can use this to determine whether a move is valid or not.

var map: GridMap:
	set(value):
		map = value
	get:
		return map

func check_move_offset(grid_position: Vector3i, grid_offset: Vector3i) -> bool:
	var modified_position := grid_position + grid_offset
	return map.get_cell_item(modified_position) != -1

func reseat_entity(entity: Entity) -> void:
	entity.grid_position = map.local_to_map(entity.position)
	entity.position = map.map_to_local(entity.grid_position)
