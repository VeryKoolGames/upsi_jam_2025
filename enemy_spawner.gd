extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_margin: int = 100
var spawn_interval = 2
@export var camera: Camera2D

func _ready() -> void:
	randomize()
	spawn_loop()

func spawn_loop():
	while true:
		await get_tree().create_timer(spawn_interval).timeout
		_spawn_enemy()

func _spawn_enemy():
	if camera == null:
		return
	
	var cam_pos = camera.global_position
	var cam_size = get_viewport_rect().size * camera.zoom  # Adjusted for zoom level
	var spawn_position = get_spawn_position(cam_pos, cam_size)
	
	var enemy = enemy_scene.instantiate() as Node2D
	enemy.global_position = spawn_position
	add_child(enemy)

func get_spawn_position(cam_pos: Vector2, cam_size: Vector2) -> Vector2:
	var side = randi() % 4

	match side:
		0: return Vector2(randf_range(cam_pos.x - cam_size.x / 2, cam_pos.x + cam_size.x / 2), cam_pos.y - cam_size.y / 2 - spawn_margin)
		1: return Vector2(randf_range(cam_pos.x - cam_size.x / 2, cam_pos.x + cam_size.x / 2), cam_pos.y + cam_size.y / 2 + spawn_margin)
		2: return Vector2(cam_pos.x - cam_size.x / 2 - spawn_margin, randf_range(cam_pos.y - cam_size.y / 2, cam_pos.y + cam_size.y / 2))
		3: return Vector2(cam_pos.x + cam_size.x / 2 + spawn_margin, randf_range(cam_pos.y - cam_size.y / 2, cam_pos.y + cam_size.y / 2))
	
	return Vector2.ZERO
