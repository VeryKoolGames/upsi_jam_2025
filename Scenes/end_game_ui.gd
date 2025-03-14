extends Control
class_name EndGameUI

@export var end_game_label: Label

var win_text = "Congratulations you won ! "
var lose_text = "Game Over"

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
	end_game_label.text += str(PlayerScore.player_score)

func _on_replay_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_button_up() -> void:
	get_tree().quit(0)
