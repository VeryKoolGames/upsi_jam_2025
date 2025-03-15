extends RigidBody2D
class_name GameShape

var is_shot: bool
var new_velocity

func _ready() -> void:
	get_node("%ShapeManager").shapes.append(self)

func _on_area_2d_area_entered(area: Area2D) -> void:
	print(area.name)
	if area.get_parent().is_in_group("enemy") and !is_shot:
		get_node("%ShapeManager").shapes.erase(self)
		print(get_node("%ShapeManager").shapes)
		area.get_parent().queue_free()
		queue_free()
	elif area.get_parent().is_in_group("enemy"):
		area.get_parent().queue_free()

func _physics_process(delta: float) -> void:
	if is_shot:
		var collision_info = move_and_collide(new_velocity * delta)
		if collision_info:
			print(collision_info)
			new_velocity = new_velocity.bounce(collision_info.get_normal())
			new_velocity.x *= 0.8
			new_velocity.y *= 0.8
