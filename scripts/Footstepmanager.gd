extends Node3D

@export var footstep_sounds : Array[AudioStreamMP3]
@export var ground_pos : Marker3D
@onready var player : CharacterBody3D = get_parent()

func _ready() -> void:
	player.step.connect(play_sound)

func play_sound():
	var audio_player : AudioStreamPlayer3D = AudioStreamPlayer3D.new()
	var random_index : int = randi_range(0, footstep_sounds.size() - 1)
	audio_player.stream = footstep_sounds[random_index]
	audio_player.pitch_scale = randf_range(0.8, 1.2)
	audio_player.volume_db = 0.0  # Set a default volume
	audio_player.bus = "Sound"  # Set a valid bus name
	ground_pos.add_child(audio_player)
	audio_player.global_position = ground_pos.global_position + Vector3(1, 1, 1)  # Set a non-zero position
	print("sigma")
	audio_player.play()
	audio_player.finished.connect(func destroy(): audio_player.queue_free())
	
