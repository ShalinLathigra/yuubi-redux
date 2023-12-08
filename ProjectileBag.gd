class_name ProjectileBag
extends Node

@export var prefab: PackedScene

var tracked_projectiles: Array[Ball]
var used_projectiles: int

var max_num_projectiles: int

func init(projectiles_to_create: int, starting_position: Vector3) -> void:
	prints("ProjectileBag instantiating balls")
	assert(prefab)
	max_num_projectiles = projectiles_to_create

func gen_projectile() -> Ball:
	var new_node = prefab.instantiate()
	tracked_projectiles.push_back(new_node)
	add_child(new_node)
	return new_node

func has_projectile_free() -> bool:
	return used_projectiles < max_num_projectiles

func get_projectile() -> Ball:
	if has_projectile_free() == false:
		return null

	used_projectiles += 1
	return gen_projectile()

func return_projectile(ball: Ball) -> void:
	tracked_projectiles.erase(ball)
	ball.call_deferred("queue_free")
	used_projectiles -= 1

func find_used_projectile_in_row(z: int) -> Ball:
	var balls = tracked_projectiles.filter(func(ball): return ball.grid_position.z == z)
	if len(balls) == 0:
		return null
	balls.sort_custom(func(a, b): return a.grid_position.z < b.grid_position.z)
	return balls[0]
