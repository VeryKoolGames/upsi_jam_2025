extends Node2D
class_name PieceMortParticle

@export var particle_one: CPUParticles2D
@export var particle_two: CPUParticles2D
@export var particle_three: CPUParticles2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_particles_color(color: Color):
	particle_one.modulate = color
	particle_two.modulate = color
	particle_three.modulate = color

func emit_particles():
	particle_one.emitting = true
	particle_three.emitting = true
	particle_two.emitting = true
