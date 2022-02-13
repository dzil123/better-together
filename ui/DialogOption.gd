extends RichTextLabel


func _ready():
	pass


func _gui_input(event):
	return
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			accept_event()
			print("pressed!")
			emit_signal("option_selected")
