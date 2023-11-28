extends Node2D

var player 
var max_health
var num_hearts
var hearts = []

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $"../.."
	max_health = player.max_health
	num_hearts = max_health/4
	var num = 0
	var heart_position = Vector2(80,560)
	while num < max_health:
		if (num != 0):
			add_child($Heart.duplicate())
		get_children()[num/4].position = heart_position
		heart_position.x += 80
		num += 4

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var num = 0
	var found_highest_current = false
	var health_looped = player.current_health
	while num < max_health:
		health_looped -= 4
		if (found_highest_current):
			get_children()[num/4].frame = 0
		elif (health_looped < 0):
			get_children()[num/4].frame = player.current_health % 4
			found_highest_current = true
		else:
			get_children()[num/4].frame = 4
		num += 4
