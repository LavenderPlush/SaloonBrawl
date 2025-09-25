extends Node2D

@onready var health_bar: HealthBar = $HealthBar
@onready var player: Player = $Player

func _ready():
	player.connect("player_hit", health_bar._on_player_hit)
	player.connect("player_death", _on_player_death)

func game_over():
	#TODO handle game overs
	player.queue_free()


#Signals
func _on_player_death():
	game_over()
