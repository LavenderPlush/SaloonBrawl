extends CharacterBody2D

class_name Barman

var targets: Array = []

@export var time_between_shots: float = 3
@export var bullet_speed: int = 600
@export var spray_angle_degrees: float = 10

@onready var timer: Timer = $Timer
@export var manager: EnemyManager

var bullet_scene: PackedScene = preload("res://Projectiles/Beer/beer.tscn")

func _ready() -> void:
	timer.start()
	manager.connect("targets_updated", _find_targets)
	if !targets.is_empty():
		timer.start(time_between_shots)
	
func _find_targets():
	var patrons: Array = manager.patrons
	for patron in patrons:
		if patron is Patron:
			targets.append(patron.global_position)
			
func shoot(target_pos: Vector2) -> void:
	var dir: Vector2 = target_pos - position
	var spray_angle: float = deg_to_rad(randf_range(-spray_angle_degrees / 2, spray_angle_degrees / 2))
	dir = dir.rotated(spray_angle)
	var movement: Vector2 = dir.normalized() * bullet_speed
	var start_pos: Vector2 = global_position + dir.normalized() * 100
	
	if abs(dir.angle()) < Vector2.DOWN.angle():
		scale.x = 1.5
	else:
		scale.x = -1.5
		
	var bullet = bullet_scene.instantiate()
	bullet.fire(start_pos, movement, self)
	get_tree().root.add_child(bullet)

func _on_timer_timeout() -> void:
	if len(targets) > 0:
		shoot(targets.pick_random())
	timer.start(time_between_shots)
