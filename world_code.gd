extends Node3D

@onready var player = $Player
var all_spawners

var current_wave = 0
var total_num_enemies = 0
var enemies_remaining = 0

var wave_can_start = true
var wave_started = false

func _ready():
	pass

func _process(delta):
	if wave_started:
		var wave_complete_check = true
		for spawner in all_spawners:
			if not spawner.wave_finished:
				wave_complete_check = false
		if wave_complete_check:
			print("wave_over!")
			wave_can_start = true
			$Player/CanvasLayer/Label.wave_started = false
	
	$Player/CanvasLayer/Label.wave_num = current_wave
	$Player/CanvasLayer/Label.remaining_enemies = enemies_remaining
	$Player/CanvasLayer/Label.total_enemies = total_num_enemies

func start_next_wave():
	if current_wave != 10:
		print(current_wave)
		wave_started = true
		wave_can_start = false
		player.current_health = player.max_health
		$Player/CanvasLayer/Label.wave_started = true
		total_num_enemies = 0
		print("beginning wave " + str(current_wave))
		all_spawners = $"All Spawners".get_children()
		for spawner in all_spawners:
			spawner.start_next_wave()
		for spawners in all_spawners:
			total_num_enemies += spawners.current_wave.num_enemies
		enemies_remaining = total_num_enemies
		current_wave += 1
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		$"Player/CanvasLayer/Game Over".text = "You Win!"
		$"Player/CanvasLayer/Game Over".visible = true
		$"Player/CanvasLayer/Reset Button".visible = true

func on_enemy_killed():
	enemies_remaining -= 1
