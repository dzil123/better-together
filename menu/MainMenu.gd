extends "res://ui/MainUI.gd"

export(GDScript) var yarn_script
const walkabout_scene = preload("res://walkabout/Walkabout.tscn")


func _ready():
	yarn.set_script(yarn_script)
	add_command(self, "run_start")


func _process(delta):
	if not in_dialog:
		begin()


func begin():
	yarn.set_current_yarn_thread("Begin")
	_step_story()


func run_start():
	# get_tree().change_scene("res://walkabout/Walkabout.tscn")
	get_node("../FadeToBlackkkk").play("FadeOut")


func actually_go():
	print("called")
	get_tree().change_scene_to(walkabout_scene)
