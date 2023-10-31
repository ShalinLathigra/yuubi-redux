extends Node

# This is going to be responsible for moving all non-player entities
# Also responsible for determining if the player hits enemies/processing hit effects.

var entities: Array[Entity]

func _ready() -> void:
	for child in get_children():
		if child is Entity:
			entities.push_back(child)


func init_grid_locations() -> void:
	for cell in MapManager.map.get_used_cells():
		prints(cell, MapManager.map.map_to_local(cell))
	for entity in entities:
		MapManager.reseat_entity(entity)
		prints(entity.name, entity.grid_position)
