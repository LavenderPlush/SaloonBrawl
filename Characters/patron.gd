extends CharacterBody2D
class_name Patron

signal death

var _targets: Array = []
var _magasine: int = 0

@export var time_between_shots = 1.5
@export var time_reload: float = 3
@export var magasine_size: int = 6

@export var bullet_speed: int = 500
@export var spray_angle_degrees: float = 20

@onready var timer: Timer = $Timer
var bullet_scene: PackedScene = preload("res://Characters/bullet.tscn")

@onready var particles: GPUParticles2D = $GPUParticles2D

@export var health: int = 5

func _ready() -> void:
	_magasine = magasine_size
	timer.connect("timeout", _on_timer_timeout)
	timer.start()


# TODO re-consider spawn position (start_pos) for the bullet
func _shoot(target_pos: Vector2) -> void:
	var dir: Vector2 = target_pos - position
	var spray_angle: float = deg_to_rad(randf_range(-spray_angle_degrees / 2, spray_angle_degrees / 2))
	dir = dir.rotated(spray_angle)
	var movement: Vector2 = dir.normalized() * bullet_speed
	var start_pos: Vector2 = global_position + dir.normalized() * 100
	
	if abs(dir.angle()) < Vector2.DOWN.angle():
		scale.x = 1
	else:
		scale.x = -1
	
	var bullet: Bullet = bullet_scene.instantiate()
	bullet.fire(start_pos, movement)
	get_tree().root.add_child(bullet)
	
	particles.emitting = true


func set_targets(targets):
	_targets = targets

func hit():
	health -= 1
	if health < 1:
		emit_signal("death", self)

#Signals
func _on_timer_timeout() -> void:
	if len(_targets) > 0:
		_shoot(_targets.pick_random())
	
	if _magasine > 0:
		_magasine -= 1
		timer.start(time_between_shots)
	else:
		_magasine = magasine_size
		timer.start(time_reload)
