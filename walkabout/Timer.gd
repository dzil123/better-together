extends Node

export(float) var starting_seconds = 180

var timer = 0  # sec, float
var room_safe = false
var is_expired = false

signal expired


func _ready():
	reset()


func _physics_process(delta):
	if is_expired:
		return

	if room_safe:
		reset()
	else:
		timer -= delta

	if timer <= 0:
		timer = 0
		is_expired = true
		emit_signal("expired")


func _input(event):  # temp debug
	if event is InputEventKey and event.pressed:
		match event.scancode:
			KEY_Z:
				if not is_expired:
					timer = 3


func reset():
	is_expired = false
	timer = starting_seconds


func get_timer_text():
	var timer_in_ms = int(timer * 1000)
	var ms = str(timer_in_ms % 1000)
	var secs = str(int(timer_in_ms / 1000) % 60)
	var mins = str(int(timer_in_ms / 60000))

	if len(secs) == 1:
		secs = "0" + secs
	while len(ms) < 3:
		ms = "0" + ms

	return mins + ":" + secs
