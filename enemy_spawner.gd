extends Node2D

@export var enemy_scene: PackedScene

func _ready() -> void:
	var enemy: PackedScene = load(enemy_scene.resource_path)
	var spawned = enemy.instantiate()
	add_child(spawned)
