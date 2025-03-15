extends MarginContainer

@export var tween_intensity: float
@export var tween_duration: float

@onready var play:TextureButton = $VBoxContainer/PlayButton
@onready var quit:TextureButton = $VBoxContainer/QuitButton

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
	get_tree().change_scene_to_file("res://Scenes/main.tscn")


func _on_quit_button_pressed() -> void:
	get_tree().quit();
