extends Control
class_name EndGameUI

var tween_intensity := 1.2
var tween_duration := 0.2

@export var end_game_label: Label
@export var scoreLabel: Label

@onready var replay:TextureButton = $VBoxContainer/replay_button
@onready var quit:TextureButton = $VBoxContainer/quit_button
@onready var main_menu:TextureButton = $VBoxContainer/MainMenuButton

var win_text = "YOU WON ! "
var lose_text = "GAME OVER !"

func _ready() -> void:
	Events.game_ended.connect(on_game_end)
	btn_hovered(replay)
	btn_hovered(quit)

func _process(delta: float) -> void:
	btn_hovered(replay)
	btn_hovered(quit)
	btn_hovered(main_menu)

func startTween(object: Object, property: String, final_val: Variant, duration:float):
	var tween = create_tween()
	tween.tween_property(object,property, final_val, duration)

func btn_hovered(button: TextureButton):
	if button.is_hovered():
		startTween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		startTween(button, "scale", Vector2.ONE, tween_duration)

func on_game_end(is_win: bool):
	await get_tree().create_timer(2).timeout
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

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
