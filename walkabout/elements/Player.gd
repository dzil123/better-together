extends Node2D

export(float, EXP) var distance_per_footstep = 1
export(Array, AudioStream) var footsteps = []
export(float, 1, 16, 0.01) var random_pitch = 1

var movable = true
var entrance = 0

var speed = 800
var distance = 0


func _ready():
	assert(distance_per_footstep > 0)

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
				movable = false
				return

	var vx = 0
	if Input.is_action_pressed("ui_left"):
		vx -= speed
	if Input.is_action_pressed("ui_right"):
		vx += speed
	position.x += vx * delta
	distance += abs(vx * delta)


func _process(delta):
	while distance > distance_per_footstep:
		distance -= distance_per_footstep
		play_footstep()


func play_footstep():
	if footsteps.size() == 0:
		return
	var sound = footsteps[randi() % footsteps.size()]
	var pitch = (1.0 / random_pitch) + randf() * (random_pitch - 1.0 / random_pitch)

	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound
	player.pitch_scale = pitch
	player.bus = "Footsteps"
	player.play()
	yield(player, "finished")
	player.queue_free()
