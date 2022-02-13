extends Node2D

export(bool) var auto_talk = false
export(String) var yarn_node = "failsafe"

var started_auto_talk = false


func get_walkabout():
	var temp = self
	while temp.name != "Walkabout":
		temp = temp.get_parent()
	return temp


func _physics_process(delta):
	if auto_talk and not started_auto_talk:
		for area in $FriendBox.get_overlapping_areas():
			if area.name == "PlayerBox":
				started_auto_talk = true
				
				var yarn = get_walkabout().find_node("YarnStory")
				yarn.set_current_yarn_thread(yarn_node)
				yarn.step_through_story()
