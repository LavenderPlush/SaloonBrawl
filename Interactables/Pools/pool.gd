extends Node2D

@onready var interactable: Interactable = $Interactable
@export var type: String
@export var pay: int

func _ready() -> void:
	visible = false
	interactable.connect("done_interacting", _on_cleaned)
	interactable.connect("area_entered", _on_area_entered)
	await get_tree().create_timer(0.2).timeout
	visible = true
	EventBus.emit_signal("add_mess", type)

func _on_area_entered(area: Area2D):
	if area.get_parent().is_in_group("Mess"):
		if area.get_rid() < interactable.get_rid():
			_remove_mess()

func _remove_mess():
	EventBus.emit_signal("remove_mess")
	EventBus.emit_signal("add_money", pay)
	queue_free()

# Signals
func _on_cleaned():
	_remove_mess()
