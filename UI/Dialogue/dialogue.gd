extends Control

# Preload faces
@onready var face_calm: Texture2D = preload("res://Assets/saloon_bartender_face_calm.png")
@onready var face_worried: Texture2D = preload("res://Assets/saloon_bartender_face_worried.png")
@onready var face_angry: Texture2D = preload("res://Assets/saloon_bartender_face_angry.png")
@onready var face_fuming: Texture2D = preload("res://Assets/saloon_bartender_face_mad_af.png")

@onready var sprite: Sprite2D = $Sprite2D
@onready var timer: Timer = $Timer

@export var angry_limit: int = 5
@export var very_angry_limit: int = 9
@export var fuming_limit: int = 12

enum MOODS {
	calm, angry, very_angry, fuming
}
var mood: MOODS = MOODS.calm

var mess_counter: int = 0

func _ready() -> void:
	EventBus.connect("add_mess", add_mess)
	EventBus.connect("remove_mess", add_mess)
	EventBus.connect("player_dead", add_mess)
	sprite.texture = face_calm

func _mess_reaction():
	match mess_counter:
		angry_limit when mood == MOODS.calm:
			sprite.texture = face_calm
		_:
			pass

# Signals
func add_mess():
	mess_counter += 1
	_mess_reaction()
	
func remove_mess():
	mess_counter -= 1
	_mess_reaction()
	
func player_dead():
	# Add line that says "press R to restart"
	sprite.texture = face_worried
	get_tree().paused = true

func player_lose_hp(hp: int):
	# Add text
	sprite.texture = face_worried
