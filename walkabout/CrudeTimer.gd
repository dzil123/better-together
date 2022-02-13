extends Label


func get_walkabout():
	var thing = self
	while thing.name != "Walkabout":
		thing = thing.get_parent()
	return thing
