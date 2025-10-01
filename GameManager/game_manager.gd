extends Node2D

@onready var health_bar: HealthBar = $UI/HealthBar
@onready var money_ui: Label = $UI/Money
@onready var player: Player = $Player

var player_money: int = 0

func _ready():
	EventBus.connect("add_money", _on_get_money)
	player.connect("player_hit", health_bar._on_player_hit)
	player.connect("player_death", _on_player_death)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("reload"):
		get_tree().reload_current_scene()
	if event.is_action_pressed("quit"):
		get_tree().quit()

func game_over():
	#TODO handle game overs
	player.queue_free()

#Signals
func _on_player_death():
	game_over()
	
func _on_get_money(amount: int):
	player_money += amount
	money_ui.text = '$' + str(float(player_money)/10)
