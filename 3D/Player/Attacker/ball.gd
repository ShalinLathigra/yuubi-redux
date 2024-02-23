extends Entity
class_name Ball

var max_range := 3

func init(grid_pos: Vector3i) -> void:
	grid_position = grid_pos + Vector3i.RIGHT
	print("starting new projectile at: ", grid_position)
	position = MapManager.map_to_local(grid_position)
	last_grid_position = grid_position

	# EntityManager -> calculate collision in this lane
	# EntityManager -> get Entity at this location
	# Delete entity
	# Ball Stops at max distance
