extends Node2D
class_name Heart

var empty_heart: Texture = preload("res://Assets/saloon_asset_hp_empty.png")
var full_heart: Texture = preload("res://Assets/saloon_asset_hp_full.png")

@onready var sprite: Sprite2D = $Sprite2D

func remove_health():
	# sprite.modulate = Color(0x060011)
	sprite.texture = empty_heart

func add_health():
	sprite.texture = full_heart
