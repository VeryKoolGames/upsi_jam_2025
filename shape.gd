extends Node2D
class_name GameShape

func _ready() -> void:
	get_node("%ShapeManager").shapes.append(self)
