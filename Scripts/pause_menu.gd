extends Control

@export var tween_intensity: float = 1.2
@export var tween_duration: float = 0.2

@onready var play: TextureButton = $VBoxContainer/RESUME
@onready var mainMenu: TextureButton = $VBoxContainer/Menu
@onready var quit: TextureButton = $VBoxContainer/QuitButton
@onready var hover_sound: AudioStreamPlayer2D = $HoverSound

var is_paused: bool = false
var has_game_ended: bool = false

func _ready():
	Events.game_ended.connect(on_game_ended)
	visible = false
	process_mode = Node.PROCESS_MODE_ALWAYS

func on_game_ended(_test: bool):
	has_game_ended = true

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause") and not has_game_ended:
		print("Pause started")
		toggle_pause()

func toggle_pause():
	is_paused = !is_paused
	get_tree().paused = is_paused
	visible = is_paused
	if is_paused:
		get_viewport().set_input_as_handled()

func startTween(object: Object, property: String, final_val: Variant, duration: float):
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.set_pause_mode(Tween.TweenPauseMode.TWEEN_PAUSE_PROCESS)
	tween.tween_property(object, property, final_val, duration)

func btn_hovered(button: TextureButton):
	if button.is_hovered():
		startTween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		startTween(button, "scale", Vector2.ONE, tween_duration)

func _on_quit_button_pressed() -> void:
	get_tree().quit()

func _on_mainmenu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Scenes/Game/GameStartMenu.tscn")

func _on_resume_pressed() -> void:
	toggle_pause()

func _on_resume_mouse_entered() -> void:
	_play_hover_sound()
	startTween(play, "scale", Vector2.ONE * tween_intensity, tween_duration)

func _play_hover_sound():
	hover_sound.pitch_scale = randf_range(0.8, 1.2)
	hover_sound.playing = true

func _on_resume_mouse_exited() -> void:
	startTween(play, "scale", Vector2.ONE, tween_duration)


func _on_quit_button_mouse_entered() -> void:
	_play_hover_sound()
	startTween(quit, "scale", Vector2.ONE * tween_intensity, tween_duration)


func _on_quit_button_mouse_exited() -> void:
	startTween(quit, "scale", Vector2.ONE, tween_duration)


func _on_menu_mouse_entered() -> void:
	_play_hover_sound()
	startTween(mainMenu, "scale", Vector2.ONE * tween_intensity, tween_duration)


func _on_menu_mouse_exited() -> void:
	startTween(mainMenu, "scale", Vector2.ONE, tween_duration)
