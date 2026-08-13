extends Control

@onready var start_button = %StartButton
@onready var options_button = %OptionsButton
@onready var quit_button = %QuitButton

func _ready() -> void:
	# attach button clicks to handlers	
	start_button.pressed.connect(_handle_start_click)
	options_button.pressed.connect(_handle_options_click)
	quit_button.pressed.connect(_handle_quit_click)

func _handle_start_click() -> void:
	print("Start clicked")
	
func _handle_options_click() -> void:
	print("Options clicked")
	
func _handle_quit_click() -> void:
	print("Quit clicked")
