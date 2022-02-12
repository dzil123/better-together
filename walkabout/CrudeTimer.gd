extends Label

func get_walkabout():
	var thing = self
	while thing.name != "Walkabout":
		thing = thing.get_parent()
	return thing

func _process(delta):
	var timer_in_ms = int(get_walkabout().timer * 1000)
	var ms = timer_in_ms % 1000
	var secs = int(timer_in_ms / 1000) % 60
	var mins = int(timer_in_ms / 60000)

	self.text = str(mins) + " : " + str(secs) + " : " + str(ms)
