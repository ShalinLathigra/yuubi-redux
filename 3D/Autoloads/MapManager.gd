extends Node

# Assign the map on level start
# Then player/entity manager can use this to determine whether a move is valid or not.

var map: GridMap:
	set(value):
		map = value
		#print(map.get_used_cells())
	get:
		return map

func check_move_offset(grid_position: Vector3i, grid_offset: Vector3i) -> bool:
	var modified_position := grid_position + grid_offset
	return map.get_cell_item(modified_position) != -1

func local_to_map(position: Vector3) -> Vector3i:
	return map.local_to_map(position)
func map_to_local(grid_position: Vector3i) -> Vector3:
	return map.map_to_local(grid_position)
