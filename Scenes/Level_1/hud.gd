extends CanvasLayer

@onready var score_value_indicator = %ScoreValue
@onready var pause_modal = %PauseModal
@onready var level_node = get_parent()
@onready var get_ready_modal = %GetReadyModal

@onready var startup_timer = %StartupTimer
@onready var countdown_label = %Counter

@onready var resume_button = %ResumeButton
@onready var quit_button = %QuitButton

var startup_tick_count = 3

func _ready() -> void:
	resume_button.pressed.connect(_handle_resume_click)
	quit_button.pressed.connect(_handle_quit_click)
	countdown_label.text = str(startup_tick_count)
	startup_timer.wait_time = 1.0
	startup_timer.one_shot = false
	startup_timer.timeout.connect(_on_startup_timer_timeout)
	startup_timer.start()

func _on_startup_timer_timeout() -> void:
	if startup_tick_count > 1:
		startup_tick_count -= 1
		_handle_startup_tick(startup_tick_count)
		countdown_label.text = str(startup_tick_count)
	else:
		startup_timer.stop()
		get_ready_modal.visible = false

func _handle_startup_tick(tick_number: int) -> void:
	print("startup tick:", tick_number)
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
