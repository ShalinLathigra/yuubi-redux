# yuubi-redux

## Project Overview

Goal of this project is to create a relatively simple 2D horde survival game
based around maintaining a consistent rhythm.

The intention is for the user to have incentives to keep a running beat by moving,
attacking, retrieving, and "beating" a drum of some kind
	(W/S = UP/DOWN, A/D = Fetch/Throw, Space = "beat")

At the time of writing this specifics for how maintaining a beat will be
encouraged are only speculated, some possibilities include:
	- Extra juice (particles, crunchy sfx, etc.)
	- Piercing attacks
	- Additional power-ups triggering on hit

## Directory Overview

- 3D
	- Deprecated work from first attempts in 3D environment
	- Eventually will return, once it is proven fun and good in 2D
- Actions
	- Code and resources surrounding our implementation of the Command pattern
	- Actions operate on Entity2Ds
- Art
	- Catchall for sprites and music, currently limited so it is unorganized
- Autoloads
	- Kitchen Sink for any and all autoload objects
	- Currently contains InputReceiver and Context
- BeatManager
	- Contains all code associated with tracking and broadcasting beats through
		the Context object
	- Includes code for displaying the Beat Info, this could live in Level/UI
		instead.
- Entities
	- Contains various scenes and scripts for different types of entities
	- Entities have no intelligence by default, they are manipulated by actions
	- "Enemies" are Entities with a provided set of actions that they will
		cycle through automatically
- Level
	- Contains scripts, scenes, resources used to instantiate a level
	- At time of writing this that is only the Grid and TestLevel scripting
	- Practically, TestLevel should be broken up into a few scripts or objects
		to handle each responsibility.
