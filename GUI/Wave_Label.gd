extends Label

var wave_num = 0
var total_enemies = 0
var remaining_enemies = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = "Wave " + str(wave_num) + " : " + str(remaining_enemies) + " / " + str(total_enemies)
