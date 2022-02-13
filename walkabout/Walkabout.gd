extends Node2D

export(Array, PackedScene) var roomIdToScene = []
export(Array, AudioStreamSample) var music_by_day = []
export(Array, int) var timer_seconds_by_day = []
export(int) var roomId = 0

var tempEntrance
var day = 0

onready var timer = $Timer
onready var yarn = find_node("YarnStory")
onready var mainui = $MainUI


func _ready():
	assert(music_by_day.size() == timer_seconds_by_day.size())
	tempEntrance = -1
	mainui.add_command(self, "set_day")
	actually_go()


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

	timer.room_safe = roomId == 0
	yarn.set_variable("day", day)


func set_day(new_day):
	print("SETTING DAY TO ", day)
	day = new_day


func _on_DialogBox_movement_enabled(is_enabled):
	for player in get_tree().get_nodes_in_group("player"):
		player.movable = is_enabled


func _on_Timer_expired():
	yarn.set_variable("lose", true)
