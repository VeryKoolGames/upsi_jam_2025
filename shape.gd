extends Node2D
class_name GameShape

var body: RigidBody2D

func _ready() -> void:
	body = get_child(0)
	add_to_group("shapes")
