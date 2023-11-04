extends Enemy
class_name Tank

@onready var shooter: Shooter = $Shooter

func die() -> void:
	super()
	shooter.die()   
