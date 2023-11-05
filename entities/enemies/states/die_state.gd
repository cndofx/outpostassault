extends State
class_name DieState

@onready var enemy: Enemy = owner

func enter(sm: StateMachine, prev_state: State) -> void:
	super(sm, prev_state)
	enemy.die()
	
	
