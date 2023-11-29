extends Node3D

@export var Enemy = preload("res://Enemies/Basic/Basic_Enemy.tscn")
@onready var timer = $Timer

@export var wave_finished = false

var waves
var current_wave
var current_wave_num = -1

var enemies_remaining_to_spawn
@export var enemies_spawned = -1

# Called when the node enters the scene tree for the first time.
func _ready():
	waves = $Waves.get_children()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func start_next_wave():
	wave_finished = false
	current_wave_num += 1
	current_wave = waves[current_wave_num]
	enemies_remaining_to_spawn = current_wave.num_enemies
	timer.wait_time = current_wave.seconds_between_spawns
	timer.start()

func _process(delta):
	pass

func _on_timer_timeout():
	if enemies_remaining_to_spawn != 0:
		var enemy = Enemy.instantiate()
		enemy.position = position
		$Enemies.add_child(enemy)
		enemies_remaining_to_spawn -= 1
		enemies_spawned += 1
	elif ($Enemies.get_child_count() == 0):
		wave_finished = true
