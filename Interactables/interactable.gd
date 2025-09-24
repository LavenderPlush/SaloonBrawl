extends Area2D
class_name interactable

signal cleaned

@export var duration: float = 2
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
		print("Progress: ", duration - $Timer.time_left, " of ", progress)
	else:
		if isInteracting:
			isInteracting = false
			progress = duration - $Timer.time_left
			$Timer.stop()
			print("Progress saved: ", progress)
	
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
	emit_signal("cleaned")
