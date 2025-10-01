extends CharacterBody2D
class_name Player

signal player_hit
signal player_death
signal player_heal

@export var move_speed: int = 500
@export var stun_duration: float = 1.0

var is_stunned: bool = false
var is_cleaning: bool = false
var is_running: bool = false
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var particle_player: CPUParticles2D = $CPUParticles2D
@onready var timer: Timer = $Timer
@onready var audio_player: AudioStreamPlayer = $AudioStreamPlayer

#NOTE hardcoded health: if changed also update the health bar
var _health: int = 5


func _ready() -> void:
	animation_player.play("RESET")
	animation_player.queue("idle")
	timer.connect("timeout", _on_timer_timeout)

func _physics_process(_delta: float) -> void:
	if not is_stunned and not is_cleaning:
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

var move_keys_down = 0
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact"):
		animation_player.play("RESET")
		animation_player.queue("clean")
		particle_player.emitting = true
		is_cleaning = true
	if event.is_action_released("interact"):
		animation_player.play("RESET")
		if not is_running:
			animation_player.queue("idle")
		else:
			animation_player.queue("running")
		particle_player.emitting = false
		is_cleaning = false
	if event.is_action_pressed("movement_keys"):
		move_keys_down += 1
		is_running = true
		particle_player.emitting = false
		is_cleaning = false
		animation_player.play("RESET")
		animation_player.queue("running")
	if event.is_action_released("movement_keys"):
		move_keys_down -= 1
		if not is_cleaning && move_keys_down == 0:
			animation_player.play("RESET")
			animation_player.queue("idle")

func hit():
	if not animation_player.current_animation == "hurt":
		animation_player.play("RESET")
		animation_player.queue("hurt")
	
	audio_player.play()
	
	_health -= 1
	if _health < 1:
		EventBus.emit_signal("player_dead")
		player_death.emit()
	else:
		EventBus.emit_signal("player_hit", _health)
		player_hit.emit()

func heal(amount: int) -> void:
	_health += amount
	if(_health > 5):
		_health = 5
	player_heal.emit(amount)

func stun():
	is_stunned = true
	timer.start(stun_duration)
	animation_player.play("RESET")
	animation_player.queue("idle")

func _on_timer_timeout():
	is_stunned = false
