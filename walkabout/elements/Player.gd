extends Node2D

var movable = true
var entrance = 0

var speed = 400


func _ready():
	for portal in get_tree().get_nodes_in_group("Portal"):
		if portal.my_entrance == entrance:
			self.position = portal.position
			break


func _physics_process(delta):
	if not movable:
		return
	
	if Input.is_action_just_pressed("ui_up"):
		var areas = $PlayerBox.get_overlapping_areas()
		for area in areas:
			if area.name == "PortalBox":
				get_tree().get_root().get_node("Walkabout").goto_room(
					area.get_parent().goto_room, area.get_parent().goto_entrance
				)
				return

	var vx = 0
	if Input.is_action_pressed("ui_left"):
		vx -= speed
	if Input.is_action_pressed("ui_right"):
		vx += speed
	position.x += vx * delta
