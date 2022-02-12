extends Node2D

var day = 0
var entrance = 0
var roomId = 0

var timer = 0
var can_reset_timer = true

export (Array, PackedScene) var roomIdToScene = [];

func _physics_process(delta):
	if roomId != 0:
		timer -= delta
	else:
		timer = 5 * 60
	
	if timer <= 0:
		$Room.emit_signal("lose")
		pass

func goto_room(id):
	roomId = id
	var roomPacked : PackedScene = roomIdToScene[roomId]
	remove_child($Room)

	var newRoom = roomPacked.instance()
	newRoom.name = "Room" # eh
	add_child(newRoom)
