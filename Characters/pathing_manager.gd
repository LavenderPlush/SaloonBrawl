extends Node2D
class_name PathingManager

var path: Array = []
var last_target: int = 0

func get_target():
	assert(path.size() > 0)
	last_target = (last_target + 1) % path.size()
	return path[last_target]
