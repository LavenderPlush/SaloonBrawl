extends Control

# Preload faces
@onready var face_calm: Texture2D = preload("res://Assets/saloon_bartender_face_calm.png")
@onready var face_worried: Texture2D = preload("res://Assets/saloon_bartender_face_worried.png")
@onready var face_angry: Texture2D = preload("res://Assets/saloon_bartender_face_angry.png")
@onready var face_fuming: Texture2D = preload("res://Assets/saloon_bartender_face_mad_af.png")

# Preload sounds
@onready var hey_calm: AudioStream = preload("res://Assets/hey_calm.mp3")
@onready var hey_angry: AudioStream = preload("res://Assets/hey_angry.mp3")
@onready var hey_fuming: AudioStream = preload("res://Assets/hey_fuming.mp3")

# Preload voicelines
@onready var voice_lines_raw: JSON = preload("res://Assets/voice_lines.tres")

@onready var sprite: Sprite2D = $Sprite2D
@onready var speech_bubble: Sprite2D = $SpeechBubble
@onready var speech_label: Label = $Label
@onready var timer: Timer = $Timer
@onready var audioPlayer: AudioStreamPlayer = $AudioStreamPlayer

@export var angry_limit: int = 5
@export var very_angry_limit: int = 10
@export var time_between_bark: int = 5
@export var hp_limit: int = 3

@onready var calm_limit: int = angry_limit - 1

enum MOODS {
	calm, angry, very_angry, fuming
}
var mood: MOODS = MOODS.calm

var barking: bool = true

var voice_lines: Dictionary

var mess_counter: int = 0

func _ready() -> void:
	timer.connect("timeout", _on_timeout)
	EventBus.connect("add_mess", add_mess)
	EventBus.connect("remove_mess", add_mess)
	EventBus.connect("player_dead", add_mess)
	EventBus.connect("player_hit", player_lose_hp)
	voice_lines = voice_lines_raw.data
	sprite.texture = face_calm
	calm_limit = angry_limit - 1
	_update_voice()
	_start_tutorial()

func _start_tutorial():
	_mess_reaction()
	_say_line("tutorial")

func _mess_reaction():
	var curr_mood = mood
	match mess_counter:
		calm_limit:
			sprite.texture = face_calm
			mood = MOODS.calm
		angry_limit:
			sprite.texture = face_angry
			mood = MOODS.angry
		very_angry_limit:
			sprite.texture = face_fuming
			mood = MOODS.fuming
		_:
			pass
	if curr_mood != mood:
		_update_voice()
	
func _update_voice():
	match mood:
		MOODS.calm:
			audioPlayer.stream = hey_calm
		MOODS.angry:
			audioPlayer.stream = hey_angry
		MOODS.fuming:
			audioPlayer.stream = hey_fuming

func _play_sound():
	audioPlayer.play()
	barking = false
	timer.start(time_between_bark)
	
func _say_line(line: String, forced: bool = false):
	if not barking and not forced:
		return
	speech_label.text = voice_lines[line].pick_random()
	speech_label.visible = true
	speech_bubble.visible = true
	_play_sound()

func _hide_speech():
	speech_label.visible = false
	speech_bubble.visible = false

# Signals
func add_mess(type: String):
	mess_counter += 1
	_mess_reaction()
	_say_line("clean_up_" + type)
	
func remove_mess():
	mess_counter -= 1
	_mess_reaction()
	if mood == MOODS.calm:
		_say_line("clean_up_calm")
	
func player_dead():
	time_between_bark *= 5
	_say_line("player_dead", true)
	sprite.texture = face_worried
	get_tree().paused = true

func player_lose_hp(hp: int):
	if hp >= hp_limit:
		return
	sprite.texture = face_worried
	_say_line("player_low_hp")

func _on_timeout():
	barking = true
	_hide_speech()
