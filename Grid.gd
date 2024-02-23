class_name Grid extends TileMap

@export var stats: GameBeatInfo
var s_per_beat: float

func _ready() -> void:
	s_per_beat = 60.0 / stats.beats_per_minute

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
								,0.75 * s_per_beat)
	entity.tween.tween_property(entity\
								, "grid_pos"\
								, entity.grid_pos + displacement,
								0)

func center_entity(entity: Entity2D) -> void:
	entity.position = map_to_local(entity.grid_pos)
