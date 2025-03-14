extends Node2D
class_name GameShape

var is_shot: bool

func _ready() -> void:
	get_node("%ShapeManager").shapes.append(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy") and !is_shot:
		get_node("%ShapeManager").shapes.erase(self)
		print(get_node("%ShapeManager").shapes)
		area.get_parent().queue_free()
		queue_free()
	elif area.get_parent().is_in_group("enemy"):
		area.get_parent().queue_free()
