################################################################################
#
# Simple label used to track and display the current Combo count + # hits
# Combo tracking should be moved to res://Autoloads/Context.gd to make it
# globally accessible.
#
################################################################################

extends Label

const combo_string: String = "COMBO: %d | %d"
var current_hits: int = 0
var combo: int = 0

func _ready() -> void:
	Context.on_input_beat.connect(handle_input)
	Context.enemy_popped.connect(handle_popped_enemy)
	update_label()

func handle_input(_input: int, _time: int, is_good: bool):
	if is_good:
		current_hits += 1
	else:
		combo -= 1
		current_hits = combo * combo
		recalculate_combo()
	update_label()

func handle_popped_enemy(num_enemies: int):
	current_hits += 10 * (num_enemies)
	recalculate_combo()
	update_label()

func recalculate_combo() -> void:
	combo = int(sqrt(float(current_hits)))

func update_label() -> void:
	text = combo_string % [combo, current_hits]
