extends Node2D

var patrons: Array[Patron] = []

func _ready() -> void:
	for c in get_children():
		patrons.append(c)
	
	for i in range(len(patrons)):
		var targets = patrons.map(func (p: Patron): return p.global_position)
		targets.remove_at(i)
		patrons[i].set_targets(targets)
