extends Node2D

@export var spawn_points: Array[Node2D]
@export var original_spawn_points: Array[Node2D]
@export var shape_scenes: Array[PackedScene]

func _ready() -> void:
	await get_tree().create_timer(1.5).timeout
	_spawn_init_shapes()

func _spawn_init_shapes():
	var i := 0
	for spawn_point in spawn_points:
		if shape_scenes.size() == 0:
			print("Error: No shape scenes available!")
			return
		await get_tree().create_timer(.2).timeout
		var new_shape = shape_scenes[randi_range(0, shape_scenes.size() - 1)].instantiate()
		new_shape.target_spawn_point = spawn_point
		new_shape.start_offset -= 0.2 * i
		if new_shape == null:
			print("Error: Failed to instantiate shape!")
			return
		add_child(new_shape)
		new_shape.global_position = original_spawn_points[i].global_position
		i += 1
