extends Node2D

@onready var player_death_sound: AudioStreamPlayer2D = $PlayerDeathSound
@onready var player_death_particles: CPUParticles2D = $PlayerDeathParticles
@export var player: Node2D
@export var main_music: AudioStreamPlayer2D

func _ready() -> void:
	Events.game_ended.connect(on_player_death)
	player = player.get_node("CharacterBody2D")

func _process(delta: float) -> void:
	if player:
		global_position = player.global_position

func on_player_death(_useless: bool):
	player_death_particles.global_position = global_position
	player_death_particles.emitting = true
	player_death_sound.playing = true
	main_music.playing = false
