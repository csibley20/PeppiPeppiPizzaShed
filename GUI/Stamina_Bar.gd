extends TextureProgressBar


func _on_timer_timeout():
	if value <= 100:
		value += 1
	$Timer.start(0.25)
