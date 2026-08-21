extends CanvasLayer

@onready var score_value_indicator = %ScoreValue
@onready var pause_modal = %PauseModal
@onready var level_node = get_parent()

@onready var resume_button = %ResumeButton
@onready var quit_button = %QuitButton

func _ready() -> void:
	resume_button.pressed.connect(_handle_resume_click)
	quit_button.pressed.connect(_handle_quit_click)
#
func _handle_quit_click() -> void:
	get_tree().paused = false # < un-pause game to allow main menu to work
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main-menu.tscn")
	
func _handle_resume_click() -> void:
	if level_node and level_node.has_method("_toggle_pause"):
		level_node.call("_toggle_pause")


var pause_modal_open = false


func update_score(value: int) -> void:
	score_value_indicator.text = str(value)
	
func toggle_pause_menu() -> void:
	pause_modal_open = !pause_modal_open
	
	if (pause_modal_open):
		pause_modal.visible = true
	else:
		pause_modal.visible = false
	
# show/hide the pause menu when pause state occurs
