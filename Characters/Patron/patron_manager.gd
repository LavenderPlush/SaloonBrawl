extends Node2D
class_name EnemyManager

signal targets_updated

@export var spawn_time: int = 5
@export var path_holder: Node2D
@export var spawn_point: Node2D

var enemy_holder: Node2D
var spawn_timer: Timer

var patron_scene: PackedScene = preload("res://Characters/Patron/patron.tscn")
var patrons: Array[Patron] = []

var paths: Array = []

func _ready() -> void:
	_load_paths()
	enemy_holder = $EnemyHolder
	spawn_timer = $SpawnTimer
	spawn_timer.wait_time = spawn_time
	spawn_timer.connect("timeout", _on_spawn_timer)
	spawn_timer.start()

func _load_paths():
	var path_nodes = path_holder.get_children()
	for path in path_nodes:
		var target_nodes = path.get_children()
		paths.append(target_nodes.map(func (pos): return pos.global_position))

func update_patron_targets():
	emit_signal("targets_updated")
	for i in range(len(patrons)):
		var targets = patrons.map(func (p: Patron): return p.global_position)
		targets.remove_at(i)
		patrons[i].set_targets(targets)

#Signals
func on_patron_death(patron: Patron):
	paths.append(patron.path.duplicate())
	patrons = patrons.filter(func (p): return p != patron)
	update_patron_targets()
	patron.queue_free()
	
func on_patron_moved():
	update_patron_targets()

func _on_spawn_timer():
	if paths.size() == 0:
		spawn_timer.start()
		return
	var patron = patron_scene.instantiate()
	patron.global_position = spawn_point.global_position
	patron.path = paths.pop_back()
	patron.connect("death", on_patron_death)
	patron.connect("moved", on_patron_moved)
	patrons.append(patron)
	enemy_holder.add_child(patron)
