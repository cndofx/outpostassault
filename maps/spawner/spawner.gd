extends Node2D

@export var objective: Node2D

@export_range(0.5, 5.0, 0.5) var spawn_rate: float = 2.0
@export var wave_count: int = 3
@export var enemies_per_wave: int = 10

var spawn_locations: Array[Node2D] = []
var current_wave: int = 0
var current_enemy_count: int = 0

@onready var spawn_container: Node2D = $SpawnContainer
@onready var wave_timer: Timer = $WaveTimer
@onready var spawn_timer: Timer = $SpawnTimer

var infantry_t1: PackedScene = preload("res://entities/enemies/infantry/infantry_t1.tscn")
var tank: PackedScene = preload("res://entities/enemies/tank/tank.tscn")

func _ready() -> void:
	await owner.ready
	for child in spawn_container.get_children():
		spawn_locations.append(child)
	wave_timer.start()
	
	# temp
	_spawn_enemy(tank)


func _start_wave():
	current_wave += 1
	spawn_timer.start()
	current_enemy_count = 0

func _end_wave():
	if current_wave < wave_count:
		wave_timer.start()

func _spawn_enemy(scene: PackedScene):
	var enemy: Enemy = scene.instantiate()
	get_parent().add_child(enemy)
	enemy.set_target(objective.global_position)
	enemy.global_position = spawn_locations.pick_random().global_position
	current_enemy_count += 1

func _on_wave_timer_timeout() -> void:
	_start_wave()


func _on_spawn_timer_timeout() -> void:
	if current_enemy_count < enemies_per_wave:
		_spawn_enemy(infantry_t1)
		var spawn_delay: float = randf_range(spawn_rate / 2.0, spawn_rate)
		spawn_timer.start(spawn_delay)
	else:
		_end_wave()
