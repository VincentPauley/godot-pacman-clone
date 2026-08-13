extends Control

@onready var main_menu_button = %MainMenuButton


func _ready() -> void:
	main_menu_button.pressed.connect(_handle_main_menu_click)

func _handle_main_menu_click() -> void:
	get_tree().change_scene_to_file("res://Scenes/MainMenu/main-menu.tscn")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
