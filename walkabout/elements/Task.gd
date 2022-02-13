extends Node2D

export(String) var yarn_bool = "got_something"

var gotten = false


func _ready():
	$VisualStuff/InteractablePrompt.visible = false


func get_walkabout():
	var temp = self
	while temp.name != "Walkabout":
		temp = temp.get_parent()
	return temp


func _physics_process(delta):
	if gotten:
		return

	var nearby = false

	for area in $InteractBox.get_overlapping_areas():
		if area.name == "PlayerBox":
			nearby = true
			if Input.is_action_just_pressed("ui_up"):
				var yarn = get_walkabout().yarn
				yarn.set_variable(yarn_bool, true)

				# self.queue_free()
				gotten = true
				visible = false

			else:
				$VisualStuff/InteractablePrompt.visible = true

	if not nearby:
		$VisualStuff/InteractablePrompt.visible = false
