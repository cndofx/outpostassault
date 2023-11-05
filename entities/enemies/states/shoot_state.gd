extends State
class_name ShootState

@onready var enemy: Enemy = owner
@onready var shooter: Shooter = enemy.get_shooter()

func enter(sm: StateMachine, prev_state: State) -> void:
	super(sm, prev_state)
	enemy.play_animation("shoot")

func update(delta: float) -> void:
	enemy._move(delta)
	if shooter.targets.size() > 0:
		shooter._rotate_shooter(delta)
		if shooter._should_shoot():
			shooter.shoot()
	else:
		state_machine.transition_to("Move")
