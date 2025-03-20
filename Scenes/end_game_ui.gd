extends Control
class_name EndGameUI

var tween_intensity := 1.2
var tween_duration := 0.2

@export var end_game_label: Label
@export var scoreLabel: Label

@onready var replay:TextureButton = $VBoxContainer/replay_button
@onready var quit:TextureButton = $VBoxContainer/quit_button
@onready var main_menu:TextureButton = $VBoxContainer/MainMenuButton
@onready var hover_sound:AudioStreamPlayer2D = $HoverSound
@export var highest_score: HighestScore
@onready var highest_score_label: Label = $VBoxContainer2/HighestScoreLabel
@onready var game_mode_label: Label = $VBoxContainer2/GameModeLabel
var saved_highest_score: int

var win_text = "YOU WON ! "
var lose_text = "GAME OVER !"

func _ready() -> void:
	Events.game_ended.connect(on_game_end)
	saved_highest_score = load_highest_score()
	btn_hovered(replay)
	btn_hovered(quit)

func _process(_delta: float) -> void:
	btn_hovered(replay)
	btn_hovered(quit)
	btn_hovered(main_menu)

func startTween(object: Object, property: String, final_val: Variant, duration:float):
	var tween = create_tween()
	tween.tween_property(object,property, final_val, duration)

func btn_hovered(button: TextureButton) -> void:
	if button.is_hovered():
		startTween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		startTween(button, "scale", Vector2.ONE, tween_duration)

func set_game_mode_label() -> void:
	game_mode_label.text =  GameMode.GameModeEnum.keys()[PlayerScore.game_mode].capitalize() + " Mode"

func set_highest_score() -> void:
	highest_score_label.text = "Highest Score: " + str(load_highest_score())

func on_game_end(is_win: bool) -> void:
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
	save_highest_score()
	scoreLabel.text += str(PlayerScore.player_score)
	set_game_mode_label()
	set_highest_score()

func save_highest_score() -> void:
	if saved_highest_score < PlayerScore.player_score:
		highest_score.player_high_score[PlayerScore.game_mode] = PlayerScore.player_score
		ResourceSaver.save(highest_score, "user://highest_score.tres")

func load_highest_score() -> int:
	if not ResourceLoader.exists("user://highest_score.tres"):
		return 0
	var highest_score_stored: HighestScore = ResourceLoader.load("user://highest_score.tres", "HighestScore")
	return highest_score_stored.player_high_score[PlayerScore.game_mode]

func _on_replay_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit(0)

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")


func _on_button_mouse_entered() -> void:
	hover_sound.pitch_scale = randf_range(0.8, 1.1)
	hover_sound.playing = true
