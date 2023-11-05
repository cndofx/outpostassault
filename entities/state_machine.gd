extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State = null

func _ready() -> void:
	await owner.ready
	self.transition_to(initial_state.name)
	
func transition_to(new_state: String):
	if has_node(new_state):
		var prev_state = current_state
		if current_state:
			current_state.exit()
		current_state = get_node(new_state)
		current_state.enter(self, prev_state)
	else:
		push_error("state %s does not exist")

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.update(delta)
