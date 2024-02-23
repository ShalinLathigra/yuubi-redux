class_name Grid extends TileMap

func move_along_grid(entity: Entity2D, displacement: Vector2i) -> void:
	if entity.tween:
		entity.tween.stop()

	if not get_cell_tile_data(0, entity.grid_pos + displacement):
			return
	entity.tween = create_tween()\
					.set_ease(Tween.EASE_IN_OUT)\
					.set_trans(Tween.TRANS_CUBIC)
	entity.tween.tween_property(entity\
								,"position"\
								,map_to_local(entity.grid_pos + displacement)\
								,0.4)\
								.set_delay(randf() * 0.1)
	entity.tween.tween_property(entity\
								, "grid_pos"\
								, entity.grid_pos + displacement,
								0)

func center_entity(entity: Entity2D) -> void:
	entity.position = map_to_local(entity.grid_pos)
