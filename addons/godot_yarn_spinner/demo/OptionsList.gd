extends Control

export(Array, NodePath) var button_paths

signal select_option(option)

var buttons = []
var options = []


func _ready():
	for index in range(button_paths.size()):
		var button_path = button_paths[index]
		var button = get_node(button_path)
		button.connect("pressed", self, "_on_option_selected", [index])
		buttons.append(button)
	reset_menu()


func _on_YarnStory_options(yarn_node, options):
	self.options = options
	for index in range(options.size()):
		if index >= buttons.size():
			push_error("too many options")
			return
		var button = buttons[index]
		var option = options[index]

		button.set_option(option)
		button.visible = true

	self.visible = true


func _on_option_selected(option):
	var option_text = options[option][0]
	reset_menu()

	emit_signal("select_option", option_text)


func reset_menu():
	self.visible = false
	self.options = false
	for button in buttons:
		button.text = ""
		button.visible = false
		button.disabled = false
