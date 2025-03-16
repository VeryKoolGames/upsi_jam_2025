extends Node2D

var current_trail: Trail
@onready var glow = %Glow
@export var box: Area2D
@export var speed: float = 200.0

var target_position: Vector2
var moving: bool = false

func _ready():
	speed *= randf_range(1, 1.8)
	make_trail()

func make_trail() -> void:
	if current_trail:
		current_trail.stop()
	current_trail = Trail.create()
	current_trail.setColor("#FF0004")
	print(current_trail)
	add_child(current_trail)
	_pick_new_target()

func _physics_process(delta: float) -> void:
	if moving:
		pass

func _pick_new_target() -> void:
	target_position = _get_random_point_in_area(box)
	_rotate_toward_target(target_position)
	_smooth_move_to_target(target_position)

func _get_random_point_in_area(area: Area2D) -> Vector2:
	var rect = area.get_child(0).shape.extents * 2
	var random_x = randf_range(area.global_position.x - rect.x / 2, area.global_position.x + rect.x / 2)
	var random_y = randf_range(area.global_position.y - rect.y / 2, area.global_position.y + rect.y / 2)
	return Vector2(random_x, random_y)

func _rotate_toward_target(target: Vector2) -> void:
	var direction = (target - global_position).normalized()
	var target_angle = direction.angle()

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation", target_angle, 0.3)

func _smooth_move_to_target(target: Vector2) -> void:
	moving = true
	var distance = global_position.distance_to(target)
	var duration = distance / speed

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", target, duration)

	await tween.finished
	moving = false
	_pick_new_target()
