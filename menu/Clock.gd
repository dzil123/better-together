extends Node

var timer = 0


func get_timer_text():
	var time = OS.get_time()
	var hour = String(time.hour)
	var minute = String(time.minute)
	if len(minute) == 1:
		minute = "0" + minute
	return hour + ":" + minute
