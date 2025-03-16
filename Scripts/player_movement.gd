extends CharacterBody2D

var speed = 600
var rotation_speed = 3.0

var current_trail: Trail

@export var end_game_canvas: EndGameUI
@export var spawn_sound: AudioStreamPlayer2D
@export var pick_up_sound: AudioStreamPlayer2D
@export var fioush_sound: AudioStreamPlayer2D

func _ready() -> void:
	add_to_group("player")
	scale = Vector2.ZERO
	var tween = create_tween()
	spawn_sound.playing = true
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5)
	Events.game_ended.connect(on_game_end)
	make_trail()
	await get_tree().create_timer(2.8).timeout
	fioush_sound.playing = true
	await get_tree().create_timer(.7).timeout
	PlayerScore.start_phase = false

func _physics_process(delta):
	if PlayerScore.start_phase:
		return
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var rotation_input = Input.get_axis("rotate_left", "rotate_right")
	velocity = direction * speed
	rotate(rotation_input * rotation_speed * delta)
	move_and_slide()

func _on_area_2d_area_entered(area: Area2D) -> void:
	if PlayerScore.start_phase:
		return
	if area.owner.is_in_group("shapes") and area.owner.can_be_picked_up:
		var shape: GameShape = area.owner
		shape.is_attached = true
		shape.is_dead = false
		shape.is_shot = false
		shape.can_be_picked_up = false
		shape.reparent(self)
		shape.snap_particle.play_pickup_particles()
		shape._switch_sprites_to_main()
		get_node("%ShapeManager").add_shape(shape)
		pick_up_sound.pitch_scale = randf_range(0.8, 1.2)
		pick_up_sound.playing = true
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(shape, "angular_velocity", 0.0, 0.2)
	elif area.owner.is_in_group("enemy"):
		on_player_death()

func on_player_death():
	Events.game_ended.emit(false)
	queue_free()

func on_game_end(_is_won: bool):
	queue_free()
	
func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail.create()
	current_trail.setColor("#ff3134")
	add_child(current_trail)
	
