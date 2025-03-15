extends CharacterBody2D

var speed = 400
var rotation_speed = 3.0

func _ready() -> void:
	add_to_group("player")

func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	var rotation_input = Input.get_axis("rotate_left", "rotate_right")
	velocity = direction * speed
	rotate(rotation_input * rotation_speed * delta)
	move_and_slide()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("shapes") and area.owner.can_be_picked_up:
		var shape: GameShape = area.owner
		shape.is_shot = false
		shape.can_be_picked_up = false
		shape.reparent(self)
		get_node("%ShapeManager").add_shape(shape)
	elif area.owner.is_in_group("enemy"):
		print("You died")
		queue_free()
