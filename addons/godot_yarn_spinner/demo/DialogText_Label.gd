# DialogText_Label.gd
extends RichTextLabel

var pg = 0

signal line_complete


func _ready():
	start_dialog("")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_activate()


func on_activate():
	if !is_line_complete():
		show_full_text()
	else:
		emit_signal("line_complete")


func show_full_text():
	visible_characters = -1


func is_line_complete():
	print("DEBUG ", visible_characters, " ", get_total_character_count())
	return visible_characters >= get_total_character_count() or visible_characters < 0


func start_dialog(dialog_text):
	set_bbcode(dialog_text)
	set_visible_characters(0)


func _on_Timer_timeout():
	if is_line_complete():
		return
	visible_characters += 1


func _on_YarnStory_dialogue(_yarn_node, _actor, message):
	start_dialog(message)


func _on_YarnStory_command(_yarn_node, command, parameters):
	print(command, parameters)
