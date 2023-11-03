extends Node2D

@export var fire_rate: float = 0.1
@export var rotation_speed: float = 5.0
@export var projectile_scene: PackedScene
@export var projectile_speed: int = 1000
@export var projectile_damage: int = 3

var targets: Array[Node2D] = []
var can_shoot: bool = true
var map: Node

@onready var gun: AnimatedSprite2D = $Gun
@onready var muzzle_flash: AnimatedSprite2D = $MuzzleFlash
@onready var shoot_sound: AudioStreamPlayer2D = $ShootSound
@onready var look_ahead: RayCast2D = $LookAhead
@onready var fire_rate_timer: Timer = $FireRateTimer
@onready var detector: Area2D = $Detector

func _ready() -> void:
	map = find_parent("Map")

func _physics_process(delta: float) -> void:
	if not targets.is_empty():
		var target_position: Vector2 = targets.front().global_position
#		var target_angle: float = self.global_position.angle_to(target_position)
		var target_angle: float = self.global_position.direction_to(target_position).angle()
		rotation = lerp_angle(self.rotation, target_angle, rotation_speed * delta)
		
		if can_shoot and look_ahead.is_colliding():
			shoot()
			
func shoot() -> void:
	can_shoot = false
	for point in gun.get_children():
		var projectile: Projectile = projectile_scene.instantiate()
		projectile.start(point.global_position, self.rotation, projectile_speed, projectile_damage)
		projectile.collision_mask = detector.collision_mask
		if map:
			map.add_child(projectile)
		else:
			owner.add_child(projectile)
	_play_animations("shoot")
	shoot_sound.play()
	fire_rate_timer.start(fire_rate)

func _play_animations(name: String) -> void:
	gun.frame = 0
	muzzle_flash.frame = 0
	gun.play(name)
	muzzle_flash.play(name)

func _on_detector_body_entered(body: Node2D) -> void:
	if body not in targets:
		targets.append(body)


func _on_detector_body_exited(body: Node2D) -> void:
	if body in targets:
		targets.erase(body)


func _on_detector_area_entered(area: Area2D) -> void:
	if area not in targets:
		targets.append(area)


func _on_detector_area_exited(area: Area2D) -> void:
	if area in targets:
		targets.erase(area)


func _on_fire_rate_timer_timeout() -> void:
	can_shoot = true


func _on_gun_animation_finished() -> void:
	if gun.animation.contains("shoot"):
		_play_animations("idle")
