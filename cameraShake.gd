extends CanvasLayer

@export var randomStrenght: float = 30
@export var shakeFade: float = 5.0

var rng = RandomNumberGenerator.new();

var shakeStrenght: float = 0.0

func apply_shake():
	shakeStrenght = randomStrenght
	

func _process(delta):
	if Input.is_action_just_pressed("shake"):
		apply_shake()
		
	if shakeStrenght > 0:
		shakeStrenght = lerpf(shakeStrenght, 0, shakeFade * delta)
		
		offset = randomOffset()
		

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrenght, shakeStrenght),rng.randf_range(-shakeStrenght, shakeStrenght))
