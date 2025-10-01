extends Node2D
class_name PathingManager

var path: Array = []
var last_target

func get_target():
	assert(path.size() > 0)
	
	var target = path.pick_random()
	while target == last_target:
		target = path.pick_random()
	
	last_target = target
	return target
