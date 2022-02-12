extends Node2D

var movable = true
var entrance = 0

func _ready():
	# find siblings, tp to the right entrance
	if get_parent() != null:
		get_parent().find_node("portal_" + str(entrance))

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_up"):
		var areas = $Area2D.get_overlapping_areas()
		for area in areas:
			if area.name == "PortalBox":
				get_tree().get_root().get_node("Walkabout").goto_room(area.get_parent().goto_room, area.get_parent().goto_entrance)
				return

	var vx = 0
	if Input.is_action_pressed("ui_left"):
		vx -= 500
	if Input.is_action_pressed("ui_right"):
		vx += 500
	position.x += vx * delta
