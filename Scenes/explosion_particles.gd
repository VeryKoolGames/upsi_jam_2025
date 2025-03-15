extends Node2D
class_name ExplosionParticle

@export var particle_one: CPUParticles2D
@export var particle_two: CPUParticles2D

func play_death_particles():
	print("PLaying particlesawait get_tree().create_timer(2.0).timeout")
	particle_one.emitting = true
	particle_two.emitting = true
