extends Control

var score: int
@export var score_label: Label
@export var timer_label: Label
@export var game_timer: Timer
var game_length := 120

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "0"
	Events.player_scored.connect(_update_score)
	game_timer.one_shot = true
	game_timer.wait_time = game_length
	game_timer.start()
	game_timer.connect("timeout", _on_timer_timeout)
	_schedule_checkpoint(game_length * 2 / 3)
	_schedule_checkpoint(game_length * 1 / 3)

func _process(delta: float) -> void:
	_update_timer()

func _update_timer():
	timer_label.text = "TIMER: " + str(int(game_timer.time_left))

func _update_score(score_to_add: int):
	score += score_to_add
	PlayerScore.player_score += score
	score_label.text = str(score)

func _on_timer_timeout():
	Events.game_ended.emit(true)

func _schedule_checkpoint(time_remaining: float) -> void:
	var checkpoint_timer = get_tree().create_timer(game_timer.time_left - time_remaining)
	await checkpoint_timer.timeout
	Events.game_progressed.emit()
