extends Node2D
class_name ExplosionParticle

@export var particle_one: CPUParticles2D

func play_death_particles():
	particle_one.emitting = true
