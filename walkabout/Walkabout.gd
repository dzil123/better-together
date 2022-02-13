extends Node2D

export(Array, PackedScene) var roomIdToScene = []
export(Array, int) var timer_seconds_by_day = []
export(int) var roomId = 0

var tempEntrance
var day = 0

onready var timer = $Timer
onready var yarn = find_node("YarnStory")
onready var mainui = $MainUI
onready var sounds = $Sounds


func _ready():
	assert(sounds.music_by_day.size() == timer_seconds_by_day.size())
	tempEntrance = -1
	mainui.add_command(self, "set_day", false)
	mainui.add_command(self, "gameover", false)
	mainui.add_command(sounds, "playsound")
	mainui.add_command(self, "playsoundsync", false)
	mainui.add_command(self, "AnimationPlayer5WackHardcoded")
	actually_go()


func goto_room(id, entrance, door_and_not_path = true):
	if $FadeToBlack.is_playing():
		return

	if id == 0 and not yarn.get_variable("door0unlocked"):
		yarn.set_current_yarn_thread("door0islocked")
		mainui._step_story()
		return

	roomId = id
	tempEntrance = entrance

	# $FadeToBlack.play("InAndOut")  # calls actually_go()
	$FadeToBlack.play("FadeOut")
	$FadeToBlack.queue("FadeIn")
	if false:
		# if door_and_not_path:
		sounds.playsound("door_creak")
	else:
		sounds.playsound("Concrete 1", 0)
		sounds.playsound("Concrete 1", 60 / 320.0)
		sounds.playsound("Concrete 1", 120 / 320.0)
		sounds.playsound("Concrete 1", 180 / 320.0)


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

	timer.starting_seconds = timer_seconds_by_day[day]
	timer.room_safe = roomId == 0
	yarn.set_variable("day", day)

	if timer.timer > 0:
		sounds._on_room_change(roomId)


func _on_DialogBox_movement_enabled(is_enabled):
	for player in get_tree().get_nodes_in_group("player"):
		player.movable = is_enabled


func _on_Timer_expired():
	sounds.end_music()
	yarn.set_variable("lose", true)
	mainui.reset()
	_on_DialogBox_movement_enabled(false)
	yarn.set_current_yarn_thread("TimeOut")
	mainui._step_story()


# commands:


func set_day(new_day):
	mainui.reset()
	_on_DialogBox_movement_enabled(false)

	day = int(new_day)
	print("SETTING DAY TO ", day)
	yarn.set_variable("day", day)
	sounds.day = day

	goto_room(0, -1)


func gameover():
	_on_DialogBox_movement_enabled(false)

	$FadeToBlack.play("GameOver")


func playsoundsync(name):
	yield(sounds.playsound(name), "completed")
	mainui._step_story()


func mainmenu():
	get_tree().change_scene("res://menu/MainMenu.tscn")


func AnimationPlayer5WackHardcoded():
	var node = find_node("AnimationPlayer5WackHardcoded") as AnimationPlayer
	if node == null:
		print("NULL AnimationPlayer5WackHardcoded")
		return
	node.play("Skedaddle")
