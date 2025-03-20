extends Resource
class_name HighestScore

@export var player_high_score: Dictionary = {}

func _init():
	if player_high_score.is_empty():
		player_high_score = {
			GameMode.GameModeEnum.HARDCORE: 0,
			GameMode.GameModeEnum.NORMAL: 0,
			GameMode.GameModeEnum.INFINITY: 0,
		}
