"""

Convenience class to abstract func calcs away from power manager

Simply put, funk is how you use powers. If your funk is high, you are strong
if low, you are weak

Funk rises faster when you act in accordance with the beat
	Combo is a representation of this.
	High Combo -> faster funk generation -> easiers to use funk without fear

funk_threshold is the number of "good points" you need to get to the next
	funk value. This value = 10+2funk^2
	Max funk costs 210
	Steps scale pretty quickly, getting to the max should be something of an
	achievement hopefully.
	etc.
"""
class_name FunkTracker extends Node

# funk members
# Doing thresholds vs progress cause why recalculate every time?
const max_funk: int = 7
var funk_thresholds: Array[int]
var funk_progress: int = 0
var funk: int = 0

# combo members
# Doing thresholds vs progress cause why recalculate every time?
const max_combo: int = 5
var combo_thresholds: Array[int]
var combo: int = 0
var good_beats: int = 0

func _ready() -> void:
	Context.on_input_beat.connect(handle_input_beat)
	for i in range(max_combo-1):
		combo_thresholds.push_back(calc_combo_threshold(i + 1))
	combo_thresholds.push_front(0)
	for i in range(max_funk):
		funk_thresholds.push_back(calc_funk_threshold(i + 1))
	print("Funk Thresholds: ", funk_thresholds)
	print("Combo Thresholds: ", combo_thresholds)

func sum_array(array: Array[int]) -> int:
	var sum = 0
	for i in array:
		sum += i
	return sum

func calc_funk_threshold(desired_funk: int) -> int:
	return sum_array(funk_thresholds) * 0.5 + 30 + 2 * pow(desired_funk, 2)

func calc_combo_threshold(desired_combo: int) -> int:
	return pow(desired_combo + 2, 2.5)

func handle_input_beat(_input: int, _time: int, is_good: bool):
	# Update Combo
	#prints("FUNK::good_beats:", good_beats, "combo:", combo, "funk_progress:", funk_progress, "funk:", funk)
	# DEBUG FOR HIGH COMBO
	#if _input == ActionRef.Type.BEAT:
		#combo = max_combo
		#good_beats = combo_thresholds[combo-1]
	if is_good:
		if combo < max_combo:
			good_beats += 1
			if good_beats > combo_thresholds[combo]:
				combo += 1
	else:
		if combo <= 0:
			good_beats = 0
		elif combo < max_combo:
			good_beats = max(0, good_beats - (combo_thresholds[combo] - combo_thresholds[combo - 1]) * 0.5 - 1)
		else:
			good_beats -= combo_thresholds[max_combo - 1] * 0.5
		combo = int(sqrt(good_beats))
	# Calculate funk
	if not is_good or funk >= max_funk:
		return
	funk_progress += combo
	if funk_progress >= funk_thresholds[funk]:
		funk += 1

	var visual_progress: float = 0
	if funk == 0:
		visual_progress = float(funk_progress) / funk_thresholds[funk]
	elif funk < max_funk:
		visual_progress = float(funk_progress - funk_thresholds[funk-1]) / (funk_thresholds[funk] - funk_thresholds[funk-1])
	else:
		visual_progress = 0
	Context.funk_changed.emit(funk, visual_progress)
