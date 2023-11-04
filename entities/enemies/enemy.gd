extends CharacterBody2D
class_name Enemy

@export var speed: int = 150
@export var rotation_speed: float = 10.0
@export var health: int = 100:
	set = set_health

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var default_sound: AudioStreamPlayer2D = $DefaultSound

func _ready() -> void:
	nav_agent.max_speed = speed
#	nav_agent.target_position = objective.global_position
	
func _physics_process(delta: float) -> void:
	var next_position: Vector2 = nav_agent.get_next_path_position()
	var current_position: Vector2 = self.global_position
	var new_velocity: Vector2 = current_position.direction_to(next_position) * speed
	self.velocity = new_velocity
	
	animated_sprite.global_rotation = lerp_angle(animated_sprite.global_rotation, velocity.angle(), rotation_speed * delta)
	collision_shape.global_rotation = lerp_angle(collision_shape.global_rotation, velocity.angle(), rotation_speed * delta)
	
	self.move_and_slide()

func set_target(target: Vector2) -> void:
	nav_agent.target_position = target

func set_health(value: int) -> void:
	health = max(0, value)
	if health == 0:
		die()
		
func die() -> void:
	collision_shape.set_deferred("disabled", true)
	speed = 0
	animated_sprite.play("die")
	default_sound.stop()


func _on_animated_sprite_2d_animation_finished() -> void:
	if animated_sprite.animation.contains("die"):
		queue_free()
