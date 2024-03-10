################################################################################
#
# Signal bus and global context holder. Accessible by all, grid and future
# resources are replaced  between levels
#
################################################################################


extends Node

signal on_input_beat(input: int, time: int, is_good: bool)
signal on_game_beat()
signal level_ready()
signal enemy_popped(num_enemies: int)
signal on_processed_beat(input: int, time: int, is_good: bool, action: Action)
signal funk_changed(funk: int, funk_progress: float)
var grid: Grid
var rock: Entity2D
var player: Player2D
var is_ready: bool = false

var combo_charges: int
var max_combo_charges: int = 3


func supply_references(g: Grid, r: Entity2D, p: Player2D) -> void:
	grid = g
	rock = r
	player = p
	is_ready = true
	level_ready.emit()
