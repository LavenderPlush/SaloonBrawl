extends Node2D
class_name EnemyManager

@export var respawn_time: int = 5

var patron_scene: PackedScene = preload("res://Characters/patron.tscn")
var patrons: Array[Patron] = []

func _ready() -> void:
	var children: Array[Patron] = []
	for c in get_children():
		children.append(c)
		c.connect("death", on_patron_death)
	update_patron_targets(children)

func update_patron_targets(new_patrons: Array[Patron]):
	patrons = new_patrons
	for i in range(len(patrons)):
		var targets = patrons.map(func (p: Patron): return p.global_position)
		targets.remove_at(i)
		patrons[i].set_targets(targets)

func respawn(pos: Vector2):
	await get_tree().create_timer(respawn_time).timeout
	var patron = patron_scene.instantiate()
	patron.global_position = pos
	add_child(patron)
	var tmp_patrons = patrons.duplicate()
	tmp_patrons.append(patron)
	update_patron_targets(tmp_patrons)

#Signals
func on_patron_death(patron: Patron):
	var new_patrons = patrons.filter(func (p): return p != patron)
	update_patron_targets(new_patrons)
	var patron_pos: Vector2 = patron.global_position
	patron.queue_free()
	respawn(patron_pos)
	
