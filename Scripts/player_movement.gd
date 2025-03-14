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
