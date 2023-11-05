extends MoveState

var shooter: Shooter

func enter(sm: StateMachine, prev_state: State) -> void:
	super(sm, prev_state)
	shooter = enemy.get_node("Shooter")
	
func update(delta: float) -> void:
	super(delta)
	if shooter and shooter.targets.size() > 0:
		shooter._rotate_shooter(delta)
		self.state_machine.transition_to("Shoot")
