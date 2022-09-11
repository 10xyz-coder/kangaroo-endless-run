extends ParallaxBackground

func _process(delta):
	scroll_offset.x -= get_parent().gameSpeed * 80 * delta
	# Very presise coordinates for scrolling background
	if scroll_offset.x < -505:
		scroll_offset.x = 830
