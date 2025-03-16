extends RigidBody2D
class_name GameShape

var is_shot: bool
var can_be_picked_up: bool
var new_velocity
var score_to_be_added: int = 10
var base_score: int
var is_attached: bool
var first_time: bool
var target_spawn_point: Node2D
@export var possible_colors: Array[Color]
@export var possible_shapes: Array[Texture2D]
@export var possible_shapes_outlines: Array[Texture2D]
@export var sprite: Sprite2D
@export var outline_sprite: Sprite2D
@export var snap_particle: SnapParticle
@export var piece_mort_particle: PieceMortParticle
var shape_manager: ShapeManager
@export var max_velocity: float = 3000.0
var is_dead: bool
@export var bounce_sound_manager: Node2D
var pick_up_sound: AudioStreamPlayer2D
var destroy_sound: AudioStreamPlayer2D
var start_offset: float = 3.5

func _ready() -> void:
	add_to_group("shapes")
	base_score = score_to_be_added
	can_be_picked_up = true
	is_dead = true
	first_time = true
	shape_manager = get_node("../%ShapeManager")
	pick_up_sound = get_node("../%PickUpSound")
	destroy_sound = get_node("../%ShapeDeathSound")
	scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.2)
	_set_random_color()
	_set_random_shape()
	_set_random_scale()
	_set_random_rotation()
	pick_up_sound.playing = true
	await get_tree().create_timer(start_offset).timeout
	_move_to_target()
	await get_tree().create_timer(0.4).timeout
	_switch_sprites_to_outline()

func _move_to_target():
	if target_spawn_point == null:
		return
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target_spawn_point.global_position, 0.4)

func _set_random_rotation():
	var random_angle = randf_range(0, 360)
	rotation = deg_to_rad(random_angle)

func _set_random_shape():
	var random_index = randi_range(0, possible_shapes.size() - 1)
	sprite.texture = possible_shapes[random_index]
	outline_sprite.texture = possible_shapes_outlines[random_index]
	snap_particle.set_textures(possible_shapes[random_index], possible_shapes_outlines[random_index])

func _set_random_color():
	var random_index = randi_range(0, possible_colors.size() - 1)
	var color = possible_colors[random_index]
	sprite.modulate = color
	outline_sprite.modulate = color
	piece_mort_particle.set_particles_color(color)

func _set_random_scale():
	var test = sprite.get_parent() as Node2D
	var rand_scale = randf_range(1, 1.4)
	test.apply_scale(Vector2(rand_scale, rand_scale))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if is_dead || PlayerScore.start_phase:
		return
	if area.get_parent().is_in_group("enemy") and is_attached:
		destroy_sound.playing = true
		is_dead = true
		shape_manager.remove_shape(self)
		area.owner.on_enemy_killed()
		piece_mort_particle.emit_particles()
		sprite.hide()
		outline_sprite.hide()
		await get_tree().create_timer(4).timeout
		queue_free()
	elif area.owner.is_in_group("enemy") and is_shot:
		score_to_be_added *= 2
		area.owner.on_enemy_killed()
		Events.emit_signal("player_scored", score_to_be_added)
		var new_scale = scale * 1.1
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(self, "scale", new_scale, 0.2)
	elif area.owner.is_in_group("shapes") and area.owner.can_be_picked_up and is_attached:
		var shape: GameShape = area.owner
		pick_up_sound.playing = true
		shape.is_attached = true
		shape.is_shot = false
		shape.is_dead = false
		shape.can_be_picked_up = false
		shape.reparent(self.get_parent())
		shape.snap_particle.play_pickup_particles()
		shape._switch_sprites_to_main()
		shape_manager.add_shape(shape)
		var tween = create_tween()
		tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		tween.tween_property(shape, "angular_velocity", 0.0, 0.2)

func on_shoot():
	is_attached = false
	await get_tree().create_timer(1).timeout
	can_be_picked_up = true

func _physics_process(delta: float) -> void:
	if is_shot:
		if new_velocity.x <= 1 and new_velocity.y <= 1 and can_be_picked_up:
			_switch_sprites_to_outline()
			score_to_be_added = base_score
		new_velocity *= 0.99
		var collision_info = move_and_collide(new_velocity * delta)
		if collision_info:
			new_velocity = new_velocity.bounce(collision_info.get_normal())
			on_collision()
			if collision_info.get_collider().is_in_group("shapes"):
				new_velocity.x *= 1.5
				new_velocity.y *= 1.5
			else:
				new_velocity.x *= 0.8
				new_velocity.y *= 0.8
			if new_velocity.length() > max_velocity:
				new_velocity = new_velocity.normalized() * max_velocity
				Events.on_hard_hit.emit()

func on_collision():
	bounce_sound_manager.play_bounce_sound()
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)
	var current_scale := scale
	current_scale.x += 0.3
	current_scale.y += 0.3
	tween.tween_property(self, "scale", current_scale, 0.1)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.1)
	

func _switch_sprites_to_outline():
	outline_sprite.show()
	sprite.hide()

func _switch_sprites_to_main():
	outline_sprite.hide()
	sprite.show()
