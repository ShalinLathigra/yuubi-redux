class_name SimpleMovingEnemy2D extends Enemy2D

@export var step: Vector2i
@export var delay_beats: int

# needs a method to decide the next step
# Enemies will create their own set of Actions in a list, then will iterate over that list
# i.e., move, wait, move, wait

func _ready() -> void:
	assert(Context.grid)
	actions.push_back(ActionFactory.BasicMove(self, Context.grid, step))
	for i in range(delay_beats):
		actions.push_back(Action.new())
	super._ready()

func handle_game_beat() -> void:
	super.handle_game_beat()
	if grid_pos.x <= 0:
		grid_pos = Vector2i(12, grid_pos.y)
		position = Context.grid.map_to_local(grid_pos)

