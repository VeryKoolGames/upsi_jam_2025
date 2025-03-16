extends MarginContainer

@export var tween_intensity: float
@export var tween_duration: float

@onready var play:TextureButton = $VBoxContainer/PlayButton
@onready var quit:TextureButton = $VBoxContainer/QuitButton

@export var button_sound: AudioStreamPlayer2D
@export var fade_overlay: ColorRect

func _process(delta: float) -> void:
	btn_hovered(play)
	btn_hovered(quit)

func startTween(object: Object, property: String, final_val: Variant, duration:float):
	var tween = create_tween()
	tween.tween_property(object,property, final_val, duration)
	

func btn_hovered(button: TextureButton):
	
	if button.is_hovered():
		startTween(button, "scale", Vector2.ONE * tween_intensity, tween_duration)
	else:
		startTween(button, "scale", Vector2.ONE, tween_duration)

func _on_play_button_pressed() -> void:
	button_sound.play()
	fade_overlay.mouse_filter = 0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.3)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit();


func _on_hard_core_button_pressed() -> void:
	button_sound.play()
	fade_overlay.mouse_filter = 0
	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 1.3)
	await tween.finished
	get_tree().change_scene_to_file("res://Scenes/hardcore.tscn")
