extends CharacterBody2D
class_name Player

signal player_hit
signal player_death

@export var move_speed: int = 500
@export var hit_cooldown: float = 1.0

var is_stunned: bool = false
@onready var timer: Timer = $Timer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

#NOTE hardcoded health: if changed also update the health bar
var _health: int = 5


func _ready() -> void:
	timer.connect("timeout", _on_timer_timeout)
	animation_player.play("idle")

func _physics_process(_delta: float) -> void:
	if not is_stunned:
		var move_direction: Vector2 = _get_input_direction()
		
		velocity = move_direction * move_speed
		move_and_slide()

func _get_input_direction() -> Vector2:
	var direction = Vector2(0.0,0.0)
	
	if Input.is_action_pressed("right"):
		direction += Vector2.RIGHT
	if Input.is_action_pressed("left"):
		direction += Vector2.LEFT
	if Input.is_action_pressed("up"):
		direction += Vector2.UP
	if Input.is_action_pressed("down"):
		direction += Vector2.DOWN
	
	return direction.normalized()


func hit():
	is_stunned = true
	timer.start(hit_cooldown)
	
	_health -= 1
	if _health < 1:
		player_death.emit()
	else:
		player_hit.emit()


#Signals
func _on_timer_timeout():
	is_stunned = false
