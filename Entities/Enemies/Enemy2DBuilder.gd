################################################################################
#
# Implementation of the Builder Pattern.
# Convenience class to handle instantiating a new enemy. Usage is as follows:
# 1. Create new Enemy2D Builder
# 2. Assign order of actions
# 3. Call build to return the enemy
#
# See "test level" for examples
#
################################################################################

class_name Enemy2DBuilder

var grid: Grid
var grid_pos: Vector2i
var actions: Array[Action]

var enemy: Enemy2D

static var enemy_scene: PackedScene = preload("res://Entities/Enemies/Enemy2D.tscn")


func _init(g: Grid, gp: Vector2i) -> void:
	grid = g
	grid_pos = gp
	enemy = enemy_scene.instantiate() as Enemy2D
	enemy.grid_pos = grid_pos
	enemy.position = grid.map_to_local(grid_pos)

func add_rest(count: int = 1) -> Enemy2DBuilder:
	for i in range(count):
		actions.push_back(ActionFactory.BasicRest())
	return self

func add_move(step: Vector2i) -> Enemy2DBuilder:
	actions.push_back(ActionFactory.BasicMove(enemy, grid, step))
	return self

func build() -> Enemy2D:
	enemy.actions = actions
	return enemy
