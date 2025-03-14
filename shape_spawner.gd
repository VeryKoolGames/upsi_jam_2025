extends Node2D

@export var spawn_points: Array[Node2D]
@export var shape_scenes: Array[PackedScene]

func _ready() -> void:
	_spawn_init_shapes()

func _spawn_init_shapes():
	for spawn_point in spawn_points:
		if shape_scenes.size() == 0:
			print("Error: No shape scenes available!")
			return
		var new_shape = shape_scenes[randi_range(0, shape_scenes.size() - 1)].instantiate() as Node2D
		if new_shape == null:
			print("Error: Failed to instantiate shape!")
			return
		add_child(new_shape)
		new_shape.global_position = spawn_point.global_position
