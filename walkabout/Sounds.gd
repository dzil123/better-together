extends Node

export(Array, AudioStream) var music_by_day = []
export(Array, String) var sfx_names
export(Array, AudioStream) var sfx_files

var day = 0
var music_is_playing = false
var sounds_dict = {}

onready var music_player = $MusicPlayer as AudioStreamPlayer
onready var music_animator = $MusicPlayer/AnimationPlayer as AnimationPlayer
onready var drone_player = $DronePlayer as AudioStreamPlayer
onready var drone_tween = $DronePlayer/Tween as Tween


func _ready():
	assert(sfx_names.size() == sfx_files.size())
	for index in range(sfx_names.size()):
		var name = sfx_names[index]
		var file = sfx_files[index]
		assert(name != "" and name != null)
		assert(file != null)
		sounds_dict[name] = file
	end_music()


func start_music():
	music_is_playing = true
	music_animator.stop()
	music_player.stream = music_by_day[day]
	music_player.volume_db = 0
	music_player.play()
	drone_tween.interpolate_property(drone_player, "volume_db", 0, -80, 0.5)
	drone_tween.start()


func end_music():
	music_is_playing = false
	music_animator.play("fadeout")
	drone_tween.interpolate_property(drone_player, "volume_db", -80, 0, 5.0)
	drone_tween.start()


func playsound(name, delay = 0):
	var sound = sounds_dict[name]

	if delay > 0:
		yield(get_tree().create_timer(delay), "timeout")

	var player = AudioStreamPlayer.new()
	add_child(player)
	player.stream = sound
	player.bus = "SFX"
	player.play()
	yield(player, "finished")
	player.queue_free()


# temp debug
func _input(event):
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_O:
				start_music()
			KEY_P:
				end_music()
			KEY_I:
				day += 1


func _on_room_change(roomId):
	if roomId == 0 and music_is_playing:
		end_music()
	if roomId != 0 and not music_is_playing:
		start_music()
