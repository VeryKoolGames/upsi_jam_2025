extends Control

var score: int
@export var score_label: Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	score_label.text = "0"
	Events.player_scored.connect(_update_score)


func _update_score(score_to_add: int):
	score += score_to_add
	score_label.text = str(score)
