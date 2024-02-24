################################################################################
#
# Signal bus and global context holder. Accessible by all, grid and future
# resources are replaced  between levels
#
################################################################################


extends Node

signal on_valid_beat(input: String, time: int, is_good: bool)
signal on_game_beat()
signal enemy_popped(num_enemies: int)

var grid: Grid
