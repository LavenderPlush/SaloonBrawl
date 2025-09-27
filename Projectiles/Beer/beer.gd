extends Area2D
class_name Beer

var velocity: Vector2 = Vector2.ZERO
var shooter_node: Node2D = null

@export var beer_splat_max: float = 80.0
@export var beer_splat_min: float = 50.0

var pool_scene: PackedScene = preload("res://Interactables/Pools/beer_pool.tscn")

func _physics_process(delta: float) -> void:
	position += velocity * delta

func fire(start_pos: Vector2, movement: Vector2, shooter: Node2D):
	shooter_node = shooter
	rotation = movement.angle()
	global_position = start_pos
	velocity = movement

func spawn_pool() -> void:
	var beer = pool_scene.instantiate()
	beer.global_position = (global_position
		+ velocity.normalized() * -1
		* (beer_splat_min + randf() * beer_splat_max - beer_splat_min))
	beer.rotation = (velocity * -1).angle()
	get_tree().root.add_child(beer)

# Signals
func _on_body_entered(body: Node2D) -> void:
	if body == shooter_node:
		return
		
	if body.is_in_group("Hitable"):
		body.hit()
		call_deferred("spawn_pool")
		
	if body.name == "Tiles":
		call_deferred("spawn_pool")
	
	if body.name != "Furniture": #Remove when cartoony tables are added.
		queue_free()
