extends CanvasLayer

export(NodePath) var timer_label_path
export(NodePath) var option_list_path
export(NodePath) var timer_path

var commands = {}
var block_progress = false
var in_dialog = false

onready var timer_label = get_node(timer_label_path) as Label
onready var options_list = get_node(option_list_path)
onready var timer = get_node(timer_path)
onready var yarn = $YarnStory
onready var topbox = $TopBox

signal movement_enabled(is_enabled)


func _init():
	pass


#	commands["set_cake_visible"] = funcref(self, "set_cake_visible")


func _ready():
	options_list.connect("select_option", self, "_on_select_option")
	yarn.set_variable("time_sec", 123)
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
		yarn.current_function = ""
		topbox.visible = false
		in_dialog = false
		emit_signal("movement_enabled", true)


func _on_YarnStory_dialogue(yarn_node, actor, message):
	topbox.visible = true
	in_dialog = true
	emit_signal("movement_enabled", false)


func _on_DialogText_Label_line_complete():
	if !block_progress:
		_step_story()


func _on_YarnStory_options(yarn_node, options):
	block_progress = true
	in_dialog = true
	emit_signal("movement_enabled", false)
	options_list._on_YarnStory_options(yarn_node, options)


func _on_select_option(option):
	block_progress = false
	in_dialog = true
	emit_signal("movement_enabled", false)
	_step_story(option)


func _on_YarnStory_command(yarn_node, command, parameters):
	print("yarn command: ", command, " ", parameters)
	if commands.has(command):
		commands[command].call_funcv(parameters)
	call_deferred("_step_story")


func string_to_bool(s):
	if s == "true":
		return true
	elif s == "false":
		return false
	else:
		push_error("fail")
