extends Node2D
class_name Heart

@onready var sprite: Sprite2D = $Sprite2D

func remove_health():
	sprite.modulate = Color(0x060011)

func add_health():
	sprite.modulate = Color(0x7e0000)
