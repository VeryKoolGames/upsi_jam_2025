extends RigidBody2D
class_name GameShape

var is_shot: bool
var can_be_picked_up: bool
var new_velocity
var score_to_be_added: int = 10

func _ready() -> void:
	add_to_group("shapes")
	get_node("%ShapeManager").shapes.append(self)
	

func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("enemy") and !is_shot:
		get_node("%ShapeManager").remove_shape(self)
		area.get_parent().queue_free()
		queue_free()
	elif area.get_parent().is_in_group("enemy"):
		score_to_be_added *= 2
		area.get_parent().queue_free()
		Events.emit_signal("player_scored", score_to_be_added)

func _physics_process(delta: float) -> void:
	if is_shot:
		new_velocity *= 0.99
		var collision_info = move_and_collide(new_velocity * delta)
		if collision_info:
			new_velocity = new_velocity.bounce(collision_info.get_normal())
			new_velocity.x *= 0.8
			new_velocity.y *= 0.8
		if new_velocity.x <= 5 and new_velocity.y <= 5:
			await get_tree().create_timer(2.0).timeout
			can_be_picked_up = true
			is_shot = false
