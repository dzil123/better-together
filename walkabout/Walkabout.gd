extends Node2D

export(Array, PackedScene) var roomIdToScene = []
export(Array, AudioStream) var music_by_day = []
export(Array, int) var timer_seconds_by_day = []
export(int) var roomId = 0

var tempEntrance
var day = 0
var music_is_playing = false

onready var timer = $Timer
onready var yarn = find_node("YarnStory")
onready var mainui = $MainUI
onready var music_player = $MusicPlayer as AudioStreamPlayer
onready var music_animator = $MusicPlayer/AnimationPlayer as AnimationPlayer


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

	timer.starting_seconds = timer_seconds_by_day[day]
	timer.room_safe = roomId == 0
	yarn.set_variable("day", day)

	if timer.timer > 0:
		if roomId == 0 and music_is_playing:
			end_music()
		if roomId != 0 and not music_is_playing:
			start_music()


func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_O:
				start_music()
			KEY_P:
				end_music()
			KEY_I:
				set_day(day + 1)


func set_day(new_day):
	print("SETTING DAY TO ", new_day)
	yarn.set_variable("day", int(new_day))
	day = int(new_day)


func start_music():
	music_is_playing = true
	music_animator.stop()
	music_player.stream = music_by_day[day]
	music_player.volume_db = 0
	music_player.play()


func end_music():
	music_is_playing = false
	music_animator.play("fadeout")


func _on_DialogBox_movement_enabled(is_enabled):
	for player in get_tree().get_nodes_in_group("player"):
		player.movable = is_enabled


func _on_Timer_expired():
	end_music()
	yarn.set_variable("lose", true)
	mainui.reset()
	_on_DialogBox_movement_enabled(false)
	yarn.set_current_yarn_thread("TimeOut")
	mainui._step_story()
