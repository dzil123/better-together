extends CanvasLayer

export(NodePath) var timer_path

var commands = {}
var block_progress = false
var in_dialog = false

onready var timer_label = $BottomBox/NinePatchRect/TimerBox/TimerLabel as Label
onready var options_list = $BottomBox/NinePatchRect/OptionsList
onready var timer = get_node(timer_path)
onready var yarn = $YarnStory
onready var topbox = $TopBox
onready var dialogtext = $TopBox/DialogBox/DialogText

signal movement_enabled(is_enabled)


func _ready():
	randomize()
	options_list.connect("select_option", self, "_on_select_option")

	add_command(self, "exit")
	add_command(self, "wait", false)
	yarn.set_variable("time_sec", 123)

	reset()
	yarn.set_current_yarn_thread("Start")
	while yarn.current_function != "":
		_step_story()


func _process(delta):
	if timer != null:
		timer_label.text = timer.get_timer_text()


func _step_story(value = null):
	if timer != null:
		yarn.set_variable("time_sec", timer.timer)
	yarn.step_through_story(value)
	if yarn.story_state == null:
		reset()


func add_command(obj, name, return_instantly = true):
	commands[name] = [funcref(obj, name), return_instantly]


func reset():
	yarn.set_current_yarn_thread("")
	topbox.visible = false
	block_progress = true
	dialogtext.show_full_text()
	in_dialog = false
	options_list.reset_menu()
	emit_signal("movement_enabled", true)
	yarn.set_variable("autoadvance", false)


func _on_YarnStory_dialogue(yarn_node, actor, message):
	if is_debug():
		call_deferred("_step_story")
		return

	block_progress = false
	topbox.visible = true
	in_dialog = true
	emit_signal("movement_enabled", false)
	dialogtext._on_YarnStory_dialogue(yarn_node, actor, message)


func _on_DialogText_Label_line_complete(complete = true):
	if (complete or yarn.get_variable("autoadvance")) and (not block_progress):
		block_progress = true
		yarn.set_variable("autoadvance", false)
		_step_story()


func _on_YarnStory_options(yarn_node, options):
	if is_debug():
		call_deferred("_on_select_option", options[0][0])
		return

	block_progress = true
	in_dialog = true
	emit_signal("movement_enabled", false)
	options_list._on_YarnStory_options(yarn_node, options)


func _on_select_option(option):
	block_progress = true
	in_dialog = true
	emit_signal("movement_enabled", false)
	yarn.set_variable("autoadvance", false)
	_step_story(option)


func _on_YarnStory_command(yarn_node, command, parameters):
	print("yarn command: ", command, " ", parameters)

	if not commands.has(command):
		print("MISSING COMMAND: ", command, " ", JSON.print(parameters))
	else:
		var fun = commands[command][0]
		var should_return = commands[command][1]

		fun.call_funcv(parameters)
		if not should_return:
			return

	call_deferred("_step_story")


# commands:


func exit():
	reset()


func wait(time):
	yield(get_tree().create_timer(float(time)), "timeout")
	_step_story()
	return


# helpers:


func string_to_bool(s):
	if s == "true":
		return true
	elif s == "false":
		return false
	else:
		push_error("fail")


func is_debug():
	return Input.is_key_pressed(KEY_SHIFT)
