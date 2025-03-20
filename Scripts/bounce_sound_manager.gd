extends Node2D

@onready var bouce_sound = $BounceAudio

func play_bounce_sound():
	var random_pitch = randf_range(0.8, 1.2)
	bouce_sound.pitch_scale = random_pitch
	bouce_sound.playing = true
 
