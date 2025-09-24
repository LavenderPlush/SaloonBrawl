extends Node2D
class_name Heart

var empty_heart: Texture = preload("res://Assets/saloon_asset_hp_empty.png")

@onready var sprite: Sprite2D = $Sprite2D

func remove_health():
	# sprite.modulate = Color(0x060011)
	sprite.texture = empty_heart

func add_health():
	sprite.modulate = Color(0x7e0000)
