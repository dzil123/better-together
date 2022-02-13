extends CanvasLayer

export(NodePath) var timer_label_path
export(NodePath) var option_list_path
export(NodePath) var timer_path

var commands = {}
var block_progress = false

onready var timer_label = get_node(timer_label_path) as Label
onready var options_list = get_node(option_list_path)
onready var timer = get_node(timer_path)
onready var yarn = $YarnStory


func _init():
	pass


#	commands["set_cake_visible"] = funcref(self, "set_cake_visible")


func _ready():
	options_list.connect("select_option", self, "_on_select_option")
	yarn.set_current_yarn_thread("TestYarn")
	yarn.step_through_story()


func _process(delta):
	if timer != null:
		timer_label.text = timer.get_timer_text()


func _step_story(value = null):
	yarn.set_variable("timer_sec", 123)
	yarn.step_through_story(value)


func _on_YarnStory_dialogue(yarn_node, actor, message):
	if !$TopBox.visible:
		$TopBox.visible = true


func _on_DialogText_Label_line_complete():
	print("foo")
	if !block_progress:
		yarn.step_through_story()


func _on_YarnStory_options(yarn_node, options):
	block_progress = true
	options_list._on_YarnStory_options(yarn_node, options)


func _on_select_option(option):
	block_progress = false
	yarn.step_through_story(option)


func _on_YarnStory_command(yarn_node, command, parameters):
	print("yarn command: ", command, " ", parameters)
	if commands.has(command):
		commands[command].call_funcv(parameters)


func string_to_bool(s):
	if s == "true":
		return true
	elif s == "false":
		return false
	else:
		push_error("fail")
