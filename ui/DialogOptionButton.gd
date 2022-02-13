extends Button

export(Color) var disabled_color = Color.coral

onready var label = $DialogOption


func set_option(option):
	disabled = not option[1]

	var text = option[0]
	if disabled:
		text = "[color=#" + disabled_color.to_html(false) + "]" + text + "[/color]"

	label.bbcode_text = text
