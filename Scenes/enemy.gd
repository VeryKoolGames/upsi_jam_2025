extends Node2D

var speed = 100  # Movement speed
var player: Node2D  # Reference to player node

@export var explosionParticles: ExplosionParticle

var current_trail: Trail

func _ready():
	make_trail()
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
	Events.on_soft_hit.emit()
	get_node("Sprite2D").hide()
	remove_from_group("enemy")
	explosionParticles.play_death_particles()
	current_trail.stop()
	await get_tree().create_timer(6.0).timeout
	queue_free()
	

func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail.create()
	current_trail.setColor("#FF0004")
	add_child(current_trail)
	
