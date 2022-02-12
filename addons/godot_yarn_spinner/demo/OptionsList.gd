extends Control

export(Array, NodePath) var button_paths

signal select_option(option)

var buttons = []


func _ready():
	for button_path in button_paths:
		buttons.append(get_node(button_path))


func _on_YarnStory_options(yarn_node, options):
	for index in range(options.size()):
		if index >= buttons.size():
			push_error("too many options")
			return
		var button = buttons[index]
		var option = options[index]

		button.text = option[0]
		button.visible = true
		button.disabled = option[1]

	self.visible = true


func _on_option_selected(option):
	reset_menu()
	emit_signal("select_option", option)


func reset_menu():
	self.visible = false
	for button in buttons:
		button.text = ""
		button.visible = false
		button.disabled = false


func _on_DialogOption1_pressed():
	_on_option_selected(0)


func _on_DialogOption2_pressed():
	_on_option_selected(1)


func _on_DialogOption3_pressed():
	_on_option_selected(2)
