extends Node2D

@onready var timer: Timer = $Timer
@export var appear_time: float = 5
@export var spawn_position: Node2D

var time: float
var sandwich_spawned: bool = false
var sandwich: Node2D = null
var sandwich_scene: PackedScene = preload("res://Interactables/sandwich.tscn")

func _ready() -> void:
	time = appear_time
	timer.start(time)
		
func _spawn_sandwich() -> void:
	sandwich = sandwich_scene.instantiate()
	sandwich.position = spawn_position.position
	get_tree().root.get_child(1).add_child(sandwich)
	
	if sandwich.has_signal("sandwich_eaten"):
		sandwich.sandwich_eaten.connect(_on_eaten)
	
func _on_eaten() -> void:
	if is_instance_valid(sandwich) && sandwich.sandwich_eaten.is_connected(_on_eaten):
		sandwich.sandwich_eaten.disconnect(_on_eaten)
	timer.start(time)
	
func _on_timer_timeout() -> void:
	_spawn_sandwich()
