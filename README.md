# yuubi-redux

# Broad Object Breakdown:

## Input Receiver
- Basically just a helper, wraps around WASD inputs and broadcasts them in
	for easy use

## Beat Tracker
- Listens for input
- When input is provided, it determines if it's been long enough since the
	last input
- If good, broadcasts input as a signal to be handled by the currently loaded
	level or whatever other object is interested

## Level
- Listens for beats from the beat tracker
- When a beat occurs, the level will update the player based on input, then
	trigger all of the other entities to update
