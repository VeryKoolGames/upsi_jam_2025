extends Node2D

@onready var warning_sprite = $Node2D

var enemy_count: int = 0

func _ready() -> void:
	warning_sprite.modulate.a = 0

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("enemy"):
		enemy_count += 1
		_fade_warning(true)

func _on_area_2d_area_exited(area: Area2D) -> void:
	if area.owner and area.owner.is_in_group("enemy"):
		enemy_count = max(enemy_count - 1, 0)
		if enemy_count == 0:
			_fade_warning(false)

func _fade_warning(visible: bool) -> void:
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_LINEAR).set_ease(Tween.EASE_OUT)
	
	if visible:
		tween.tween_property(warning_sprite, "modulate:a", 1.0, 0.3)
	else:
		tween.tween_property(warning_sprite, "modulate:a", 0.0, 0.5)
