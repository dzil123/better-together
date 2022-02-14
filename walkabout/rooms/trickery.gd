extends Node


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var player = get_node("../Player")
	if player.position.x < -1024 / 2:
		player.position.x += 1024 * 4
	if player.position.x > 1024 * 3 + 1024 / 2:
		player.position.x -= 1024 * 4
