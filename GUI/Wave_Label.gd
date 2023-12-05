extends Label

var wave_num = 0
var total_enemies = 0
var remaining_enemies = 0

var wave_started = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wave_started:
		text = "Wave " + str(wave_num) + " : " + str(remaining_enemies) + " / " + str(total_enemies)
	else:
		text = "Shoot the Freezer Door to start the next wave"
