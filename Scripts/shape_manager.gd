extends Node2D
class_name ShapeManager

var shapes: Array[Node]
var closest_shape: GameShape
var should_launch: bool = true
@export var aim_line: Line2D

	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_pressed():
			return
		if closest_shape:
			print(closest_shape)
			should_launch = false
			_launch_shape_towards_mouse()

func _process(delta: float) -> void:
	closest_shape = _get_closest_node_to_mouse()
	_draw_aim_line()

func _get_closest_node_to_mouse() -> GameShape:
	if (!shapes.size() || !should_launch):
		return null
	var mouse_pos = get_global_mouse_position()
	var nearest_shape = shapes[0]
	if not nearest_shape:
		return null
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

func remove_shape(shape):
	if shapes.has(shape):
		shapes.erase(shape)

func add_shape(shape):
	if not shapes.has(shape):
		shapes.append(shape)

func _launch_shape_towards_mouse() -> void:
	closest_shape.is_shot = true
	var original_global_pos = closest_shape.global_position
	shapes.erase(closest_shape)
	var old_parent = closest_shape.get_parent()
	old_parent.remove_child(closest_shape)
	owner.add_child(closest_shape)
	closest_shape.global_position = original_global_pos
	var mouse_pos = get_global_mouse_position()
	var velocity_vector = mouse_pos - closest_shape.global_position
	velocity_vector = velocity_vector * 4
	closest_shape.on_shoot()
	closest_shape.new_velocity = velocity_vector
	should_launch = true
	closest_shape = null

func _draw_aim_line():
	if closest_shape:
		aim_line.clear_points()
		aim_line.add_point(closest_shape.global_position, 0)
		aim_line.add_point(get_global_mouse_position(), 1)
	else:
		aim_line.clear_points()
