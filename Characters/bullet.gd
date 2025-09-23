extends Area2D
class_name Bullet

var _movement: Vector2 = Vector2(0,0)

func _ready() -> void:
	connect("body_entered", _on_body_entered)

func _physics_process(delta: float) -> void:
	position += _movement * delta


func fire(start_pos: Vector2, movement: Vector2):
	rotation = movement.angle()
	global_position = start_pos
	_movement = movement


# Signals
func _on_body_entered(_body: Node2D) -> void:
	queue_free()
