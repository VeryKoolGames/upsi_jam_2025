extends Control
class_name EndGameUI

@export var end_game_label: Label
@export var scoreLabel: Label

var win_text = "YOU WON ! "
var lose_text = "GAME OVER !"

func _ready() -> void:
	Events.game_ended.connect(on_game_end)

func on_game_end(is_win: bool):
	scale = Vector2.ZERO
	visible = true
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1, 1), 0.5) \
		.set_trans(Tween.TRANS_BOUNCE) \
		.set_ease(Tween.EASE_OUT)
	if is_win:
		end_game_label.text = win_text
	else:
		end_game_label.text = lose_text
	scoreLabel.text += str(PlayerScore.player_score)

func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)
