extends Control

var score: int
@export var score_label: Label
@export var timer_label: Label
@export var game_timer: Timer
var has_ended: bool

var is_starting: bool = true 
var game_length := 120

func _ready() -> void:
	Events.game_ended.connect(on_player_death)
	score_label.text = "0"
	timer_label.text = "TIMER: 120" if not PlayerScore.game_mode == GameMode.GameModeEnum.INFINITY else "INFINITE"
	Events.player_scored.connect(_update_score)
	
	await get_tree().create_timer(6).timeout
	if not PlayerScore.game_mode == GameMode.GameModeEnum.INFINITY:
		_start_normal_game()

func _start_normal_game():
	is_starting = false
	game_timer.one_shot = true
	game_timer.wait_time = game_length
	game_timer.start()
	game_timer.connect("timeout", _on_timer_timeout)
	_schedule_checkpoint(game_length * 2 / 3)
	_schedule_checkpoint(game_length * 1 / 3)

func _process(delta: float) -> void:
	if not PlayerScore.game_mode == GameMode.GameModeEnum.INFINITY:
		_update_timer()

func _update_timer():
	if is_starting || has_ended:
		return
	timer_label.text = "TIMER: " + str(int(game_timer.time_left))

func _update_score(score_to_add: int):
	score += score_to_add
	PlayerScore.player_score = score
	score_label.text = str(score)
	var intensity = clamp(score_to_add / 50.0, 1.0, 2.0) 
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_BOUNCE).set_ease(Tween.EASE_OUT)

	tween.tween_property(score_label, "scale", Vector2(1.2, 1.2) * intensity, 0.1)

	tween.tween_property(score_label, "rotation_degrees", randf_range(-10, 10) * intensity, 0.05)
	tween.tween_property(score_label, "rotation_degrees", 0, 0.05)

	tween.tween_property(score_label, "scale", Vector2.ONE, 0.1)

func _on_timer_timeout():
	Events.game_ended.emit(true)

func _schedule_checkpoint(time_remaining: float) -> void:
	var checkpoint_timer = get_tree().create_timer(game_timer.time_left - time_remaining)
	await checkpoint_timer.timeout
	Events.game_progressed.emit()

func on_player_death(_useless: bool):
	has_ended = true
	game_timer.stop()
