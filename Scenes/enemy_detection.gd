extends Node2D

@export var warning_sprite: Sprite2D

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("enemy"):
		warning_sprite.visible = true
