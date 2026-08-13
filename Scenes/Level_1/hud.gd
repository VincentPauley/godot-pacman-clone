extends CanvasLayer

@onready var score_value_indicator = %ScoreValue

func update_score(value: int) -> void:
	score_value_indicator.text = str(value)
