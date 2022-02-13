extends Label
tool
# func _ready():
# 	if not Engine.editor_hint:
# 		visible = false


func _process(delta):
	var portal = get_parent()
	self.text = (
		str(portal.goto_room)
		+ " "
		+ str(portal.goto_entrance)
		+ "\n"
		+ str(portal.my_entrance)
	)
