extends Node2D

var patrons: Array[Patron] = []

func _ready() -> void:
	var tmp_patrons: Array[Patron] = []
	for c in get_children():
		tmp_patrons.append(c)
		c.connect("death", on_patron_death)
	
	update_patron_targets(tmp_patrons)

func update_patron_targets(new_patrons: Array[Patron]):
	patrons = new_patrons
	for i in range(len(patrons)):
		var targets = patrons.map(func (p: Patron): return p.global_position)
		targets.remove_at(i)
		patrons[i].set_targets(targets)

#Signals
func on_patron_death(patron: Patron):
	var new_patrons = patrons.filter(func (p): return p != patron)
	update_patron_targets(new_patrons)
	patron.queue_free()
