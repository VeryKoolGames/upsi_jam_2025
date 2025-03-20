extends MarginContainer

@export var tween_intensity: float
@export var tween_duration: float

@onready var play:TextureButton = $VBoxContainer/PlayButton
@onready var quit:TextureButton = $VBoxContainer/QuitButton
@onready var hardcore:TextureButton = $VBoxContainer/HardCoreButton
@onready var infinite:TextureButton = $VBoxContainer/InfiniteMode
@onready var sound:AudioStreamPlayer2D = $AudioStreamPlayer2D

@export var button_sound: AudioStreamPlayer2D
@export var fade_overlay: ColorRect

func _process(delta: float) -> void:
	btn_hovered(play)
	btn_hovered(quit)
	btn_hovered(hardcore)
	btn_hovered(infinite)

func startTween(object: Object, property: String, final_val: Variant, duration:float):
	var tween = create_tween()
	tween.tween_property(object, property, final_val, duration)
	

func btn_hovered(button: TextureButton):
	if button.is_hovered():
		startTween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		startTween(button, "scale", Vector2.ONE, tween_duration)

func _on_play_button_pressed() -> void:
	PlayerScore.game_mode = GameMode.GameModeEnum.NORMAL
	_play_scene_transition("res://Scenes/main.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit();

func _play_scene_transition(scene_path: String):
	button_sound.play()
	fade_overlay.mouse_filter = 0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.5)
	await tween.finished
	get_tree().change_scene_to_file(scene_path)

func _on_hard_core_button_pressed() -> void:
	PlayerScore.game_mode = GameMode.GameModeEnum.HARDCORE
	_play_scene_transition("res://Scenes/hardcore.tscn")

func _on_infinite_mode_pressed() -> void:
	PlayerScore.game_mode = GameMode.GameModeEnum.INFINITY
	_play_scene_transition("res://Scenes/infinite.tscn")

func _on_play_button_mouse_entered() -> void:
	sound.pitch_scale = randf_range(0.9, 1.1)
	sound.playing = true
