class_name MovingEnemy2D extends Enemy2D

@export_multiline var encoded_moves: String

# needs a method to decide the next step
# Enemies will create their own set of Actions in a list, then will iterate over that list
# i.e., move, wait, move, wait

func _ready() -> void:
	var json = JSON.new()
	var error = json.parse(encoded_moves)
	var action_sequence = Helpers.parse_action_json_to_sequence(name, encoded_moves)
	assert(Context.grid, "Missing Context: Grid")
	actions = ActionFactory.EnemyActionsFromSequence(self, Context.grid, action_sequence)
	super._ready()
