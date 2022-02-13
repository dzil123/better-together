extends RichTextLabel

export(NodePath) var options_icon_path
export(NodePath) var continue_icon_path

onready var options_icon = get_node(options_icon_path)
onready var continue_icon = get_node(continue_icon_path)

signal line_complete


func _ready():
	options_icon.visible = false
	continue_icon.visible = false
	start_dialog("")


func _input(event):
	if event.is_action_pressed("ui_accept"):
		on_activate()


func on_activate():
	if !is_line_complete():
		show_full_text()
		emit_signal("line_complete", false)
	else:
		emit_signal("line_complete")


func show_full_text():
	visible_characters = -1


func is_line_complete():
	return visible_characters >= get_total_character_count() or visible_characters < 0


func start_dialog(dialog_text: String):
	dialog_text = dialog_text.c_unescape()
	set_bbcode(dialog_text)
	set_visible_characters(0)


func _on_Timer_timeout():
	continue_icon.visible = is_line_complete()
	if is_line_complete():
		return
	visible_characters += 1
	if is_line_complete():
		emit_signal("line_complete", false)


func _on_YarnStory_dialogue(_yarn_node, _actor, message):
	start_dialog(message)
