extends Node2D

signal sandwich_eaten

@onready var interactable: Interactable = $Interactable

@export var hp_restored: int = 2
var player: Player = null

func _ready() -> void:
	interactable.connect("done_interacting", _on_eaten)

func _on_eaten() -> void:
	player.heal(hp_restored)
	sandwich_eaten.emit()
	queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		player = body;
