extends Node2D

var speed = 100  # Movement speed
var player: Node2D  # Reference to player node

@export var explosionParticles: ExplosionParticle

func _ready():
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	if !player:
		push_error("Enemy cannot find player node!")

func _process(delta):
	if !player:
		return
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	rotation = direction.angle()

func on_enemy_killed():
	get_node("Sprite2D").hide()
	explosionParticles.play_death_particles()
	await get_tree().create_timer(1.0).timeout
	queue_free()
