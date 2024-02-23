extends Node

# This is going to be responsible for handling all interactions with entities
# 	- Initial reseating using the map manager
# 	- Knowledge of what row entities are currently occupying
# Also responsible for determining if the player hits enemies/processing hit effects.

var entities: Array[Entity]
var player: Entity
var grid_z_to_entities: Dictionary

func _ready() -> void:
	grid_z_to_entities = {}
	for entity in get_tree().get_nodes_in_group("Entity"):
		add_entity(entity)
	BeatTracker.beat.connect(do_entity_beat_updates)

func add_entity(entity: Entity) -> void:
	entities.push_back(entity)
	add_entity_to_z_map(entity)

func remove_entity(entity: Entity) -> void:
	entities.erase(entity)
	remove_entity_from_z_map(entity)

func add_entity_to_z_map(entity: Entity):
	if not grid_z_to_entities.get(entity.grid_position.z):
		grid_z_to_entities[entity.grid_position.z] = []
	grid_z_to_entities[entity.grid_position.z].push_back(entity)

func remove_entity_from_z_map(entity: Entity):
	if not grid_z_to_entities.get(entity.grid_position.z):
		prints("Error removing ", entity.name, ".", "No entities exist at z index:", entity.grid_position.z)
		return
	var z_arr = grid_z_to_entities[entity.grid_position.z]
	var index = z_arr.find(entity)
	if index < 0:
		prints("Error removing ", entity.name, "Cannot be found in set at z index:", entity.grid_position.z)
		return
	z_arr.erase(entity)

func do_entity_beat_updates() -> void:
	#get all objects in the "Entity Mover" group
	for entity in entities:
		if entity.has_method("do_beat_update"):
			# If it's position changes during this tick, then do that.
			entity.do_beat_update()

func reseat_entities() -> void:
	for entity in entities:
		reseat_entity(entity)

func reseat_entity(entity: Entity) -> void:
	entity.grid_position = MapManager.local_to_map(entity.position)
	entity.position = MapManager.map_to_local(entity.grid_position)
	#print(entity.position, entity.target_position)

func hop_body_to_offset(body: Entity, offset: Vector3i, hop_height: float, beat_duration_ratio: float) -> void:
	var last_target_position = body.target_position
	if MapManager.check_move_offset(body.grid_position, offset):
		body.target_position = MapManager.map_to_local(body.grid_position + offset)
		var last_grid_position = body.grid_position
		body.grid_position += offset
		# if the new position is on a different z index than the last one, then shift it along.
	var move_duration: float = BeatTracker.seconds_per_beat * beat_duration_ratio

	var tween = body.tween
	if tween:
		tween.stop()
	tween = create_tween().set_parallel()
	tween.tween_property(body, "position:x", body.target_position.x, move_duration).from(last_target_position.x)
	tween.tween_property(body, "position:z", body.target_position.z, move_duration).from(last_target_position.z)
	tween.tween_property(body, "position:y", body.target_position.y + hop_height, move_duration * 0.5).from(last_target_position.y)
	tween.chain().tween_property(body, "position:y", body.target_position.y, move_duration * 0.5).from(body.target_position.y + hop_height)
	#prints(body.name, last_target_position, body.target_position)
	await tween.finished

func detect_collisions_between_points(start: Vector3i, end: Vector3i) -> Array[Entity]:
	return []
