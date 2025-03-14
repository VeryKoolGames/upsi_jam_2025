extends Node2D

var shapes: Array[Node]
var closest_shape: GameShape

func _ready() -> void:
	shapes = get_tree().get_nodes_in_group("shapes")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			return
		if closest_shape:
			print("Event triggered")
			_launch_shape_towards_mouse()

func _process(delta: float) -> void:
	closest_shape = _get_closest_node_to_mouse()

func _get_closest_node_to_mouse() -> GameShape:
	if (!shapes.size()):
		return null
	var mouse_pos = get_viewport().get_mouse_position()
	var nearest_shape = shapes[0]
	var near_pos = nearest_shape.global_position
	var near_sqr = mouse_pos.distance_squared_to(near_pos)
	for i in range(1, shapes.size()):
		var obj = shapes[i]
		var pos = obj.global_position
		var sqr = mouse_pos.distance_squared_to(pos)
		if (sqr < near_sqr):
			near_sqr = sqr
			nearest_shape = obj
	return nearest_shape

func _launch_shape_towards_mouse() -> void:
	closest_shape.remove_from_group("shapes")
	closest_shape.get_parent().remove_child(closest_shape)
	owner.add_child(closest_shape)
	var mouse_pos = get_global_mouse_position()
	var velocity_vector = mouse_pos - closest_shape.global_position
	closest_shape.body.apply_impulse(velocity_vector)
	shapes = get_tree().get_nodes_in_group("shapes")
