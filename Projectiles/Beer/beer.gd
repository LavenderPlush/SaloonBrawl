extends Area2D
class_name Beer

var velocity: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO
var shooter_node: Node2D = null

@export var move_base_speed: int = 300

@export var fuse_time: float = 1.0
@onready var timer: Timer = $Timer

var pool_scene: PackedScene = preload("res://Interactables/Pools/beer_pool.tscn")

func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	timer.start(fuse_time)

func _physics_process(delta: float) -> void:
	position += velocity * delta

func fire(start_pos: Vector2, movement: Vector2, shooter: Node2D):
	shooter_node = shooter
	rotation = movement.angle()
	global_position = start_pos
	direction = movement.normalized()
	velocity = direction * move_base_speed

func spawn_pool() -> void:
	var beer = pool_scene.instantiate()
	beer.global_position = (global_position + velocity.normalized() * -1)
	beer.rotation = (velocity * -1).angle()
	get_tree().root.add_child(beer)

# Signals
func _on_body_entered(body: Node2D) -> void:
	if body == shooter_node:
		return
		
	if body.is_in_group("Player"):
		body.stun()
		queue_free()
		call_deferred("spawn_pool")
		
	if body.is_in_group("Hitable") && !body.is_in_group("Player"):
		body.hit()
		queue_free()
		call_deferred("spawn_pool")
		
	if body.name == "Tiles":
		queue_free()
		
func _on_timer_timeout():
	queue_free()
	call_deferred("spawn_pool")
