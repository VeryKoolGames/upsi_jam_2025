extends Control

var score: int
@export var score_label: Label
@export var timer_label: Label
@export var game_timer: Timer
@export var fade_overlay: ColorRect

var is_starting: bool = true
var game_length := 120

func _ready() -> void:
	score_label.text = "0"
	timer_label.text = "TIMER: 120"
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 1)
	await tween.finished
	fade_overlay.queue_free()
	Events.player_scored.connect(_update_score)
	
	await get_tree().create_timer(4).timeout
	is_starting = false
	game_timer.one_shot = true
	game_timer.wait_time = game_length
	game_timer.start()
	game_timer.connect("timeout", _on_timer_timeout)
	_schedule_checkpoint(game_length * 2 / 3)
	_schedule_checkpoint(game_length * 1 / 3)

func _process(delta: float) -> void:
	_update_timer()

func _update_timer():
	if is_starting:
		return
	timer_label.text = "TIMER: " + str(int(game_timer.time_left))

func _update_score(score_to_add: int):
	score += score_to_add
	PlayerScore.player_score = score
	score_label.text = str(score)
	var intensity = clamp(score_to_add / 50.0, 1.0, 2.0)  # Adjust 50.0 for balancing

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2) * intensity, 0.1)

	tween.tween_property(score_label, "rotation_degrees", randf_range(-10, 10) * intensity, 0.05)
	tween.tween_property(score_label, "rotation_degrees", 0, 0.05)  # Reset rotation

	tween.tween_property(score_label, "scale", Vector2.ONE, 0.1)

func _on_timer_timeout():
	Events.game_ended.emit(true)

func _schedule_checkpoint(time_remaining: float) -> void:
	var checkpoint_timer = get_tree().create_timer(game_timer.time_left - time_remaining)
	await checkpoint_timer.timeout
	Events.game_progressed.emit()
