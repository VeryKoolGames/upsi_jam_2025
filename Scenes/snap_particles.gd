extends Node2D
class_name SnapParticle

@export var particle_one: CPUParticles2D
@export var particle_two: CPUParticles2D

func set_textures(texture_one: Texture2D, texture_two: Texture2D):
	particle_one.texture = texture_one
	particle_two.texture = texture_two

func play_pickup_particles():
	particle_one.emitting = true
	particle_two.emitting = true
