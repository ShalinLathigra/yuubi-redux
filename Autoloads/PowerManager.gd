extends Node
# Object References
var funk_tracker: FunkTracker # Interface through which we access "Funk" value

# Test Powers
var powers: Array[Power]
var power: MovePower

# Tracked Variables
var elapsed_beats: int

func _ready() -> void:
	Context.on_game_beat.connect(handle_game_beat)
	funk_tracker = $FunkTracker as FunkTracker
	power = MovePower.new(ActionRef.Type.THROW, Vector2i(2, 0), "res://Art/discobolus.svg", 2)
	# Provide the action type, the replacement action, and an method to apply the new
	# action to the old one?
	# What if actions have additional factory methods?
	powers.push_back(power)

func handle_game_beat() -> void:
	elapsed_beats += 1

func process_action(input: int, action: Action) -> void:
	# for each action with this input trigger:
	# if correct input and power level reached, pass it off
	for power in powers:
		if not power.is_satisfied():
			continue
		if power is MovePower and input == power.type:
			power.invoke(action as MoveAction)
	#if input == "THROW" && stored_funk > 3:
		#(action as MoveAction).displacement.x += 2
