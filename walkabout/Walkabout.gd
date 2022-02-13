extends Node2D

export(Array, PackedScene) var roomIdToScene = []

var day = 0
export(int) var roomId = 0

var can_reset_timer = true

onready var timer = $Timer


func _ready():
	# roomId = 0
	tempEntrance = -1
	actually_go()


var tempEntrance


func goto_room(id, entrance):
	if $FadeToBlack.is_playing():
		return

	roomId = id
	tempEntrance = entrance

	$FadeToBlack.play("InAndOut")  # calls actually_go()
	timer.room_safe = roomId == 0


func actually_go():
	remove_child($Room)

	var newRoom = roomIdToScene[roomId].instance()
	newRoom.name = "Room"  # eh
	newRoom.get_node("Player").entrance = tempEntrance

	add_child(newRoom)

	if day != 0:
		for node in get_tree().get_nodes_in_group("day0"):
			node.queue_free()
	if day != 1:
		for node in get_tree().get_nodes_in_group("day1"):
			node.queue_free()
	if day != 2:
		for node in get_tree().get_nodes_in_group("day2"):
			node.queue_free()
	if day != 3:
		for node in get_tree().get_nodes_in_group("day3"):
			node.queue_free()
	if tempEntrance != 1:
		for node in get_tree().get_nodes_in_group("entrance1"):
			node.queue_free()


func _on_DialogBox_movement_enabled(is_enabled):
	for player in get_tree().get_nodes_in_group("player"):
		player.movable = is_enabled
