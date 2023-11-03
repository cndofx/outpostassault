extends CharacterBody2D
class_name Enemy

@export var speed: int = 150
#@export var objective: Node2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D

func _ready() -> void:
	nav_agent.max_speed = speed
#	nav_agent.target_position = objective.global_position
	
func _physics_process(delta: float) -> void:
	var next_position: Vector2 = nav_agent.get_next_path_position()
	var current_position: Vector2 = self.global_position
	var new_velocity: Vector2 = current_position.direction_to(next_position) * speed
	self.velocity = new_velocity
	self.move_and_slide()

func set_target(target: Vector2) -> void:
	nav_agent.target_position = target
