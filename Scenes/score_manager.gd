extends Control

var score: int
@export var score_label: Label
@export var timer_label: Label
@export var game_timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "SCORE: 0"
	Events.player_scored.connect(_update_score)
	game_timer.one_shot = true
	game_timer.wait_time = 30
	game_timer.start()
	game_timer.connect("timeout", _on_timer_timeout)

func _process(delta: float) -> void:
	_update_timer()

func _update_timer():
	timer_label.text = str(int(game_timer.time_left))

func _update_score(score_to_add: int):
	score += score_to_add
	score_label.text = "SCORE: " + str(score)

func _on_timer_timeout():
	print("Game Done")
