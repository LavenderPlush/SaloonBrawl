extends CharacterBody2D
class_name Patron

signal death
signal moved

var path: Array
var is_moving: bool = true

var _targets: Array = []
var _magasine: int = 0

var pathing_manager: PathingManager
var navigation_agent: NavigationAgent2D

@export_category("Properties")
@export var movement_speed: int = 200
@export var health: int = 5
@export var chance_to_move: float = 0.1

@export_category("Weapon")
@export var time_between_shots: float = 1.5
@export var time_reload: float = 3
@export var magasine_size: int = 6

@export var bullet_speed: int = 500
@export var spray_angle_degrees: float = 20

@onready var timer: Timer = $Timer
var bullet_scene: PackedScene = preload("res://Projectiles/Bullet/bullet.tscn")

@export var bomb_chance: float = 0.1
var bomb_scene: PackedScene = preload("res://Projectiles/Bomb/bomb.tscn")

@onready var particles: GPUParticles2D = $GPUParticles2D

func _ready() -> void:
	pathing_manager = $PathingManager
	pathing_manager.path = path
	navigation_agent = $NavigationAgent2D
	navigation_agent.connect("target_reached", _on_reached_target)
	_magasine = magasine_size
	timer.connect("timeout", _on_shoot_timer)
	navigation_agent.target_position = pathing_manager.get_target()

func _physics_process(_delta: float) -> void:
	if is_moving:
		move()

func move():
	var path_position = navigation_agent.get_next_path_position()
	velocity = global_position.direction_to(path_position) * movement_speed
	move_and_slide()

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
	
	#NOTE consider abstracting out projectiles
	if randf() < bomb_chance:
		var bomb = bomb_scene.instantiate()
		bomb.fire(start_pos, movement)
		get_tree().root.add_child(bomb)
	else:
		var bullet = bullet_scene.instantiate()
		bullet.fire(start_pos, movement)
		get_tree().root.add_child(bullet)
		_magasine -= 1
	
		particles.emitting = true


func set_targets(targets):
	_targets = targets

func hit():
	health -= 1
	if health < 1:
		emit_signal("death", self)

func _begin_movement():
	navigation_agent.target_position = pathing_manager.get_target()
	is_moving = true

#Signals
func _on_shoot_timer() -> void:
	if is_moving: return
	if pathing_manager:
		if randf() < chance_to_move:
			_begin_movement()
			return
	
	if len(_targets) > 0:
		_shoot(_targets.pick_random())
	
	if _magasine > 0:
		timer.start(time_between_shots)
	else:
		_magasine = magasine_size
		timer.start(time_reload)

func _on_reached_target():
	is_moving = false
	timer.start(time_between_shots)
	emit_signal("moved")
