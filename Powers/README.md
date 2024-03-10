# Combo manager
- Responsible for orchestrating all interactions with the Combo system

- Combo system involves:

- Continuously increasing "Funk" meter
- Faster increase for successive beats (incentivize playing on beat)
- Also faster for using the "beat" action
	- potential for even faster ability usage!

- Powers are additional effects that the player gets access to when above a
		certain Funk threshold
	- Funk threshold configured from the PowerConfigurationUI
	- Each power has a configured set of slots it is able to take up
	- If already filled, will need to prioritize

	-------------------------------------------------------------
	|  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  10 |
	-------------------------------------------------------------
	|  _  |  _  |  _  |  _  |  _  |  _  |  _  |  _  |  _  |  _  |
	-------------------------------------------------------------
	| A | B | C | D | E | F | G | H ||  Name: A
	|   |   |   |   |   |   |   |   ||  Description: Lorem Ipsum
	|   |   |   |   |   |   |   |   ||  ViableFunkOptions[1, 3, 5]
	-------------------------------------------------------------


- Powers have the following sense of state:
	- When an ability is ENABLED, it will be listening for events and actively
			applying whatever effects it has
	- Examples:
		- Sharp Rocks
			- FunkOptions: 3, 4, 5
			- Effect:
				- Every 5th beat
				- If a "THROW" input starts, it will pierce all enemy clusters
		- Strong Beats
			- FunkOptions: 6, 7, 8
			- Effect:
				- Every 3rd Beat Action
				- Send wave forward from starting point
					- 3 tiles long
		- Long Toss
			- FunkOptions: 1, 3, 5
			- Effect:
				- Every Throw Action
				- Increase Range by 2


In order to make this I need the following:
- Create a simple first Power - Long Toss?
- Create the Power manager, will be responsible for setting up
		signal connections and updating input beats

- Do we need to adjust the input flow?
	- Input -> InputReceiver -> BeatManager -> ActionManager(->PowerManager) -> Player
		- Input is the keypress
		- Receiver ties in time and sends it on
		- BeatManager determines if it's a good or bad input
		- ActionManager creates the action, refers to PowerManager to handle effects
		- PowerManager determines what Powers affect that Action, make modifications as needed
		- Player adds it to the queue

Done
1. Create the empty PowerManager, have it pass input through to player
2. Have PowerManager track # good inputs from BeatManager and enemies killed
3. Create FunkBar to display and animate changes in Funk

TODO
4. Create First Passive Power, at > 3 Funk, on "Throw" input, make it pierce
	- Add config field to Rock2D.gd, is_piercing
5. Update FunkBar to display icons for each power in their configured slot
6. Create First Active Power, at > 3 Funk, on "Beat" -> "Fetch" input
		- take out enemies on the backswing
		- replace the fetch action's trigger with "set_live: true"
7. Come up with syntax for creating abilities more easily
	- More variety in action types
	- Add configuration options to them
	- Some abilities contain functions that take in an Action and alter them?
	- Easier Signal listening, passing results from signals directly through to
			Ability?
