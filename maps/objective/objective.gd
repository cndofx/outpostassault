extends Area2D

@export var health: int = 500:
	set = set_health
	
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func set_health(value: int) -> void:
	health = max(0, value)
	if health == 0:
		collision_shape.set_deferred("disabled", true)
		animated_sprite.play("die")


func _on_body_entered(body: Node2D) -> void:
	if body is Infantry:
		var infantry: Infantry = body
		health -= infantry.objective_damage
		infantry.queue_free()
