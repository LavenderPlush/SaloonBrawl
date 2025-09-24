extends Sprite2D

func _ready() -> void:
	$Interactable.connect("done_interacting", _on_cleaned)
	
func _on_cleaned():
	queue_free()
