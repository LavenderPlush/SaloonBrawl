extends Area2D
class_name interactable

signal done_interacting

@export var duration: float = 2
@export var pay: int = 1
var progress: float = 0
var in_range: bool = false
var is_interacting: bool = false

@onready var cleaning_bar: TextureProgressBar = null

@export var big_sprite: Sprite2D
@export var small_sprite: Sprite2D

func _ready():
	var timer = $Timer
	if big_sprite:
		big_sprite.visible = true
	if small_sprite:
		small_sprite.visible = false
	if timer:
		timer.connect("timeout", _on_timer_timeout)
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

func _process(_delta: float) -> void:
	if is_interacting and cleaning_bar:
		cleaning_bar.value = duration - $Timer.time_left
		if (duration - $Timer.time_left) >= duration / 2:
			if big_sprite:
				big_sprite.visible = false
			if small_sprite:
				small_sprite.visible = true
		else:
			if big_sprite:
				big_sprite.visible = true
			if small_sprite:
				small_sprite.visible = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("interact") and in_range:
		is_interacting = true
		$Timer.start(duration - progress)
		if cleaning_bar:
			cleaning_bar.visible = true

	if event.is_action_released("interact") or event.is_action_pressed("movement_keys"):
		if not in_range:
			return
		is_interacting = false
		progress = duration - $Timer.time_left
		$Timer.stop()
		if cleaning_bar:
			cleaning_bar.visible = false
	
func _on_body_entered(object):
	if object.is_in_group("Player"):
		in_range = true
		cleaning_bar = object.get_node_or_null("CleaningBar")
		if cleaning_bar:
			cleaning_bar.max_value = duration
			cleaning_bar.value = progress
			cleaning_bar.visible = false
		
func _on_body_exited(object):
	if object.is_in_group("Player"):
		in_range = false
		if is_interacting:
			is_interacting = false
			progress = duration - $Timer.time_left
			$Timer.stop()
			if cleaning_bar:
				cleaning_bar.visible = false
			cleaning_bar = null
	
func _on_timer_timeout():
	progress = 0
	if cleaning_bar:
		cleaning_bar.visible = false
		cleaning_bar.value = 0
	EventBus.emit_signal("add_money", pay)
	emit_signal("done_interacting")
