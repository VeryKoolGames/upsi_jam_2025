extends Node2D

var shapes: Array[Node]
var closest_shape: GameShape
var should_launch: bool = true

#func _ready() -> void:
	#shapes = get_tree().get_nodes_in_group("shapes")
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			return
		if closest_shape:
			should_launch = false
			_launch_shape_towards_mouse()

func _process(delta: float) -> void:
	closest_shape = _get_closest_node_to_mouse()

func _get_closest_node_to_mouse() -> GameShape:
	if (!shapes.size() || !should_launch):
		return null
	var mouse_pos = get_global_mouse_position()
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

#func _remove_shape_from_list(shape_to_remove):
	#for shape in shapes:
		#if shape == shape_to_remove:
			

func _launch_shape_towards_mouse() -> void:
	print("Launching closest shape " + closest_shape.name)
	closest_shape.collision_layer = 2
	var original_global_pos = closest_shape.global_position
	shapes.erase(closest_shape)
	var old_parent = closest_shape.get_parent()
	old_parent.remove_child(closest_shape)
	owner.add_child(closest_shape)
	closest_shape.global_position = original_global_pos
	var mouse_pos = get_global_mouse_position()
	var velocity_vector = mouse_pos - closest_shape.global_position
	velocity_vector = velocity_vector * 1.2
	closest_shape.apply_impulse(velocity_vector)
	should_launch = true
	print("Launched closest shape " + closest_shape.name)

	closest_shape = null
