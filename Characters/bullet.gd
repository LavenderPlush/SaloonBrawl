extends Area2D
class_name Bullet

@export var blood_splat_range: float = 2.0
@export var blood_chance: float = 0.2

var _movement: Vector2 = Vector2(0,0)
var blood_scene: PackedScene = preload("res://Interactables/blood.tscn")

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	position += _movement * delta


func fire(start_pos: Vector2, movement: Vector2):
	rotation = movement.angle()
	global_position = start_pos
	_movement = movement

func spawn_blood() -> void:
	if randf() > blood_chance:
		return
	var blood = blood_scene.instantiate()
	blood.global_position = global_position + _movement * -1 * (randf() * blood_splat_range)
	blood.rotation = (_movement * -1).angle()
	get_tree().root.add_child(blood)

# Signals
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Hitable"):
		body.hit()
		call_deferred("spawn_blood")
	
	queue_free()
