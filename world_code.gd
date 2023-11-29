extends Node3D

@onready var player = $Player
var all_spawners

var current_wave = 0
var total_num_enemies = 0
var enemies_remaining = 0

func _ready():
	start_next_wave()

func _process(delta):
	var wave_complete = true
	for spawner in all_spawners:
		if not spawner.wave_finished:
			wave_complete = false

	if wave_complete:
		start_next_wave()
	
	$Player/CanvasLayer/Label.wave_num = current_wave
	$Player/CanvasLayer/Label.remaining_enemies = enemies_remaining
	$Player/CanvasLayer/Label.total_enemies = total_num_enemies

func start_next_wave():
	total_num_enemies = 0
	print("beginning wave " + str(current_wave))
	all_spawners = $"All Spawners".get_children()
	for spawner in all_spawners:
		spawner.start_next_wave()
	for spawners in all_spawners:
		total_num_enemies += spawners.current_wave.num_enemies
	enemies_remaining = total_num_enemies
	current_wave += 1

func on_enemy_killed():
	enemies_remaining -= 1
