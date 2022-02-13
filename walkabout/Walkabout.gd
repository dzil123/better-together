extends Node2D

export(Array, PackedScene) var roomIdToScene = []

var day = 0
var roomId = 0

var can_reset_timer = true

onready var timer = $Timer


func _ready():
	roomId = 0
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
