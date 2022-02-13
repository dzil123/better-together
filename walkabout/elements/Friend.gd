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
	var nearby = false
	var player_hack = null

	for area in $FriendBox.get_overlapping_areas():
		if area.name == "PlayerBox":
			nearby = true
			player_hack = area.get_parent()

			if (
				(auto_talk and not started_auto_talk)
				or (Input.is_action_just_pressed("ui_up") and player_hack.movable)
			):
				started_auto_talk = true

				var yarn = get_walkabout().yarn
				yarn.set_current_yarn_thread(yarn_node)
				yarn.step_through_story()

	$VisualStuff/InteractablePrompt.visible = (
		nearby
		and (player_hack != null and player_hack.movable)
	)
