extends Label

func get_walkabout():
	var thing = self
	while thing.name != "Walkabout":
		thing = thing.get_parent()
	return thing

func _process(delta):
	var timer_in_ms = int(get_walkabout().timer * 1000)
	var ms = str(timer_in_ms % 1000)
	var secs = str(int(timer_in_ms / 1000) % 60)
	var mins = str(int(timer_in_ms / 60000))

	if len(secs) == 1:
		secs = "0" + secs
	while len(ms) < 3:
		ms = "0" + ms

	self.text = mins + " : " + secs + " : " + ms
