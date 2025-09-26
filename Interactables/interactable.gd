extends Area2D
class_name interactable

signal done_interacting

@export var duration: float = 2
@export var pay: float = 0.1
var progress: float = 0
var inRange: bool = false
var isInteracting: bool = false

func _ready():
	var timer = $Timer
	if timer:
		timer.connect("timeout", _on_timer_timeout)
	self.connect("body_entered", _on_body_entered)
	self.connect("body_exited", _on_body_exited)

func _process(_delta):
	if inRange and Input.is_action_pressed("interact"):
		if not isInteracting:
			isInteracting = true
			$Timer.start(duration - progress)
	else:
		if isInteracting:
			isInteracting = false
			progress = duration - $Timer.time_left
			$Timer.stop()
	
func _on_body_entered(object):
	if object.is_in_group("Player"):
		inRange = true
		print("Player entered the area.")
		
func _on_body_exited(object):
	if object.is_in_group("Player"):
		inRange = false
		if isInteracting:
			isInteracting = false
			progress = duration - $Timer.time_left
			$Timer.stop()
			print("Progress saved: ", progress)
	
func _on_timer_timeout():
	progress = 0
	EventBus.emit_signal("add_money", pay)
	emit_signal("done_interacting")
