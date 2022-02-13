extends Label


func _process(delta):
	var dict = get_parent().get_parent().find_node("YarnStory").variables
	var walkabout = get_parent().get_parent()

	self.text = ""
	for key in dict:
		self.text += str(key) + "   " + str(dict[key]) + "\n"

	self.text += "day" + "   " + str(walkabout.day) + "\n"

	var player = get_tree().root.find_node("Player")
	if player != null:
		self.text += "movable" + "   " + str(player.movable) + "\n"
		# no clue why this doesn't work
