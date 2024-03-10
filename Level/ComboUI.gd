extends Control
################################################################################
#
# Simple label used to track and display the current Combo count + # hits
# Combo tracking should be moved to res://Autoloads/Context.gd to make it
# globally accessible.
#

"""

Alrighty, so what are we going to need to do?

Combo is used to charge your power meter
higher combo == more abilities activatable

Want to display "frets" along the board, lines which when active, glow blue
	User can check that out and use it to determine what abilities are going
	to toggle when

"Beat" used to trigger the highest rated "active" ability, or maybe it's a dual
cast thing. Press two things and your next input is an ability trigger?

Would love to be able to alter the beat map over time,
	- i.e. trigger an ability to double BPM and let you mash for a bit
	- unlock a thing which causes every nth beat to heal you
	- etc.

Power meter reflects what abilities are enabled at what time
	- i.e. power 1 trigger
	- power 2 trigger
	- on lose power 1
	- on enter power 1

Certain abilities consume power, others are weaker and just take effect when
	above a certain power threshold

Abilities have a constraint indicating where they can be slotted in.

"""


################################################################################


const combo_string: String = "COMBO: %d | %3.2f"
var current_hits: int = 0
var combo: int = 0
var claim: int = 0
var next_claim_threshold: int = 32
var claim_progress: int = 0

var label: Label
var claim_panel: Panel
var frets: Array[Sprite2D]

func _ready() -> void:
	Context.on_input_beat.connect(handle_input)
	Context.enemy_popped.connect(handle_popped_enemy)

	label = $Label as Label
	claim_panel = $Panel as Panel

	for child in get_children():
		if "Fret" in child.name:
			frets.push_back(child as Sprite2D)
	update_display()

func handle_input(_input: int, _time: int, is_good: bool):
	if is_good:
		current_hits += 1
		claim_progress += combo + 1
		if claim_progress > next_claim_threshold:
			next_claim_threshold = clamp(pow(2, claim), 32, 256)
			claim_progress = 0
			claim += 1
	else:
		#combo -= 1
		#current_hits = combo * combo
		current_hits = max(0, current_hits - 0.25 * (pow(combo + 1, 2) - pow(combo, 2)))
		#claim_progress = max(0, claim_progress - 0.25 * next_claim_threshold)
	recalculate_combo()
	update_display()

func handle_popped_enemy(num_enemies: int):
	current_hits += 10 * num_enemies
	if claim < 9:
		claim_progress += clamp(pow(claim, 2), 2, 16) * num_enemies
		if claim_progress > next_claim_threshold:
			next_claim_threshold = clamp(pow(2, claim), 32, 256)
			claim_progress = 0
			claim += 1
	recalculate_combo()
	update_display()

func recalculate_combo() -> void:
	combo = int(sqrt(float(current_hits)))

func update_display() -> void:
	var progress_to_next = float(current_hits - pow(combo, 2)) / (pow(combo + 1, 2) - pow(combo, 2))
	label.text = combo_string % [combo, progress_to_next]
	claim_panel.scale.x = claim + float(claim_progress) / next_claim_threshold
	for i in range(len(frets)):
		frets[i].modulate = Color.AQUA if claim >= (i+1) * 3 else Color.DARK_MAGENTA
		#:
		#else:
			#frets[i].modulate = Color.DARK_MAGENTA
