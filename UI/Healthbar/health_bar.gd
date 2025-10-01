extends Control
class_name HealthBar

var _health = 5
var _max_health = 5
var _hearts: Array[Heart] = []

@onready var heart_container: HBoxContainer = $HeartContainer

func _ready():
	var children = heart_container.get_children()
	for i in range(_health):
		_hearts.append(children[i].get_child(0))

func _on_player_hit():
	_health -= 1
	_hearts[_health].remove_health()

func _on_player_heal(amount: int):
	for i in range(amount):
		if _health == _max_health:
			break
		_health += 1
		_hearts[_health - 1].add_health()
