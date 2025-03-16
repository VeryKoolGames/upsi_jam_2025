extends Node2D

var speed = 140
var player: Node2D

@export var explosionParticles: ExplosionParticle

var current_trail: Trail
@onready var glow = %Glow
@export var death_sound: AudioStreamPlayer2D

func _ready():
	_randomize_speed()
	Events.game_progressed.connect(on_game_state_change)
	make_trail()
	add_to_group("enemy")
	player = get_tree().get_first_node_in_group("player")
	if !player:
		push_error("Enemy cannot find player node!")

func _randomize_speed():
	speed *= randf_range(1.1, 1.3)

func _process(delta):
	if !player:
		return
	var direction = (player.global_position - global_position).normalized()
	global_position += direction * speed * delta
	rotation = direction.angle()

func on_enemy_killed():
	Events.on_soft_hit.emit()
	get_node("Sprite2D").hide()
	death_sound.pitch_scale = randf_range(1, 2.3)
	death_sound.playing = true
	remove_from_group("enemy")
	glow.queue_free()
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
	
func on_game_state_change():
	speed += 20
