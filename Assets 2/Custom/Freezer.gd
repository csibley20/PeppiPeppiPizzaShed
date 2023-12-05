extends Node3D

var world

# Called when the node enters the scene tree for the first time.
func _ready():
	world = get_parent()

func trigger():
	if world.wave_can_start:
		world.start_next_wave()
