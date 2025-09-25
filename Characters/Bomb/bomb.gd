extends Area2D
class_name Bomb

@export var move_base_speed: int = 100
@export var move_acceleration: float = 1.05
var _direction: Vector2 = Vector2.ZERO
var _velocity: Vector2 = Vector2.ZERO

@export var fuse_time: float = 1.0
@onready var timer: Timer = $Timer

@export var fragment_count = 5
@export var fragment_speed = 200
var _fragment_angle = 2 * PI / fragment_count
var fragment = preload("res://Characters/bullet.tscn")

var _blowing_up = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	connect("body_entered", _on_body_entered)
	timer.connect("timeout", _on_timer_timeout)
	timer.start(fuse_time)

func _physics_process(delta: float) -> void:
	_velocity *= move_acceleration
	position += _velocity * delta

func fire(start_pos: Vector2, movement: Vector2):
	rotation = movement.angle()
	global_position = start_pos
	_direction = movement.normalized()
	_velocity = _direction * move_base_speed

func blow_up():
	if _blowing_up:
		return
	
	_blowing_up = true
	
	_velocity = Vector2.ZERO
	animation_player.play("explode")
	
	for i in range(fragment_count):
		var angle = _fragment_angle * i
		var movement = Vector2.from_angle(angle) * fragment_speed
		var start_pos = global_position + movement.normalized()
		var fragment_curr = fragment.instantiate()
		fragment_curr.fire(start_pos, movement)
		get_tree().root.add_child(fragment_curr)
	
	queue_free()

#Signals
func _on_timer_timeout():
	blow_up()

func _on_body_entered(body: Node2D):
	if body.is_in_group("Hitable"):
		body.hit()
	call_deferred("blow_up")
