extends Node2D

var day = 0
var roomId = 0

var timer = 0
var can_reset_timer = true

export(Array, PackedScene) var roomIdToScene = []


func _ready():
	goto_room(0, -1)


func _physics_process(delta):
	if roomId != 0:
		timer -= delta
	else:
		timer = 3 * 60

	if timer <= 0:
		$Room.emit_signal("lose")
		pass


var tempEntrance


func goto_room(id, entrance):
	if $FadeToBlack.is_playing():
		return

	roomId = id
	tempEntrance = entrance

	$FadeToBlack.play("InAndOut")  # calls actually_go()


func actually_go():
	remove_child($Room)

	var newRoom = roomIdToScene[roomId].instance()
	newRoom.name = "Room"  # eh
	newRoom.get_node("Player").entrance = tempEntrance
	add_child(newRoom)
