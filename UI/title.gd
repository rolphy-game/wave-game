extends Control


@onready var start: Button = %Start
@onready var levels: Button = %Levels
@onready var quit: Button = %Quit
@onready var how_to_play_screen: Control = %HowToPlayScreen
@onready var exit: Button = %Exit
@onready var how_play_button: Button = %HowPlayButton
@onready var how_play_screen_init_x_pos := how_to_play_screen.global_position.x
var tween: Tween


func _ready() -> void:
	how_to_play_screen.visible = false
	start.pressed.connect(global_signals.start_game.emit.bind(1))
	levels.pressed.connect(global_signals.level_menu.emit)
	how_play_button.pressed.connect(_show_how_to_play_screen)
	exit.pressed.connect(_hide_how_to_play_screen)
	quit.pressed.connect(get_tree().quit)


func _show_how_to_play_screen() -> void:
	Music.select.play()
	how_to_play_screen.visible = true
	if tween and tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(how_to_play_screen, "position:x", how_play_screen_init_x_pos - 1200.0, 2.0)


func _hide_how_to_play_screen()-> void:
	Music.select.play()
	if tween.is_running():
		tween.kill()
	tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)
	tween.tween_property(how_to_play_screen, "position:x", how_play_screen_init_x_pos, 2.0)
	await tween.finished
	how_to_play_screen.visible = false
