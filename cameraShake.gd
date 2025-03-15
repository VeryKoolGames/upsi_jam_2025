extends CanvasLayer

@export var randomStrenght: float = 30
@export var shakeFade: float = 5.0
var rng = RandomNumberGenerator.new();
var shakeStrenght: float = 0.0
var shake_cooldown := 0.5

func _ready() -> void:
	Events.on_hard_hit.connect(apply_shake)
	Events.on_soft_hit.connect(apply_small_shake)

func apply_shake():
	shakeStrenght = randomStrenght

func apply_small_shake():
	shakeStrenght = 5

func _start_shakedown_cooldown():
	pass

func _process(delta):
	if shakeStrenght > 0:
		shakeStrenght = lerpf(shakeStrenght, 0, shakeFade * delta)
		offset = randomOffset()

func randomOffset() -> Vector2:
	return Vector2(rng.randf_range(-shakeStrenght, shakeStrenght),rng.randf_range(-shakeStrenght, shakeStrenght))
