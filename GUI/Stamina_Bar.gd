extends TextureProgressBar


func _on_timer_timeout():
	if value <= 100 and not Input.is_action_pressed("sprint"):
		value += 5
	$Timer.start(0.5)
