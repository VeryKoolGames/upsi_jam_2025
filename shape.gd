extends Node2D
class_name GameShape

var body: RigidBody2D

func _ready() -> void:
	body = get_child(0)
	add_to_group("shapes")

#func _process(delta: float) -> void:
	#print(transform)

func move_towards_mouse(target):
	var tween := create_tween ().set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN_OUT)
	print(target)
	tween.tween_property(self, "global_position", target, 1.0)
