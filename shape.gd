extends RigidBody2D
class_name GameShape

var is_shot: bool
var can_be_picked_up: bool
var new_velocity
var score_to_be_added: int = 10
var is_attached
@export var possible_colors: Array[Color]
@export var possible_shapes: Array[Texture2D]
@export var possible_shapes_outlines: Array[Texture2D]
@export var sprite: Sprite2D
@export var outline_sprite: Sprite2D
@export var snap_particle: SnapParticle
var shape_manager: ShapeManager

func _ready() -> void:
	add_to_group("shapes")
	shape_manager = get_node("../%ShapeManager")
	shape_manager.shapes.append(self)
	_set_random_color()
	_set_random_shape()
	_set_random_scale()

func _set_random_shape():
	var random_index = randi_range(0, possible_shapes.size() - 1)
	sprite.texture = possible_shapes[random_index]
	outline_sprite.texture = possible_shapes_outlines[random_index]
	snap_particle.set_textures(possible_shapes[random_index], possible_shapes_outlines[random_index])

func _set_random_color():
	var random_index = randi_range(0, possible_colors.size() - 1)
	sprite.modulate = possible_colors[random_index]
	outline_sprite.modulate = possible_colors[random_index]

func _set_random_scale():
	var test = sprite.get_parent() as Node2D
	var rand_scale = randf_range(1, 2)
	test.apply_scale(Vector2(rand_scale, rand_scale))

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy") and !is_shot:
		shape_manager.remove_shape(self)
		area.owner.on_enemy_killed()
		queue_free()
	elif area.owner.is_in_group("enemy"):
		score_to_be_added *= 2
		area.owner.on_enemy_killed()
		Events.emit_signal("player_scored", score_to_be_added)
	elif area.owner.is_in_group("shapes") and area.owner.can_be_picked_up and not is_shot:
		var shape: GameShape = area.owner
		shape.is_shot = false
		shape.can_be_picked_up = false
		shape.reparent(self.get_parent())
		shape.snap_particle.play_pickup_particles()
		shape._switch_sprites_to_main()
		shape_manager.add_shape(shape)

func on_shoot():
	await get_tree().create_timer(0.5).timeout
	can_be_picked_up = true

func _physics_process(delta: float) -> void:
	if is_shot:
		if new_velocity.x <= 10 and new_velocity.y <= 10 and can_be_picked_up:
			_switch_sprites_to_outline()
		new_velocity *= 0.99
		var collision_info = move_and_collide(new_velocity * delta)
		if collision_info:
			new_velocity = new_velocity.bounce(collision_info.get_normal())
			if collision_info.get_collider().is_in_group("shapes"):
				new_velocity.x *= 1.5
				new_velocity.y *= 1.5
			else:
				new_velocity.x *= 0.8
				new_velocity.y *= 0.8

func _switch_sprites_to_outline():
	outline_sprite.show()
	sprite.hide()

func _switch_sprites_to_main():
	outline_sprite.hide()
	sprite.show()
