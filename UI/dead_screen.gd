extends Control


@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
var current_level


func _ready() -> void:
	restart_button.pressed.connect(global_signals.start_game.emit.bind(current_level))
	main_menu_button.pressed.connect(global_signals.main_title.emit)
