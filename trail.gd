class_name Trail
extends Line2D


const MAX_POINTS : int = 70

@onready var trailColor : Color
@onready var curve := Curve2D.new()

func _process(delta: float) -> void:
	curve.add_point(get_parent().position)
	if curve.get_baked_points().size() > MAX_POINTS:
		curve.remove_point(0)
	points = curve.get_baked_points()
	
func stop() -> void:
	set_process(false)
	queue_free()
	
static func create() -> Trail:
	var scn = preload("res://trail.tscn")
	return scn.instantiate()
	
func setColor(color: Color) -> void:
	if gradient:
		gradient.set_color(0, "#011f37")
		gradient.set_color(1, color)
