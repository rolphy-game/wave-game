extends Control


@onready var restart_button: Button = %RestartButton
@onready var main_menu_button: Button = %MainMenuButton
@onready var next_level_button: Button = %NextLevelButton
@onready var score_label: Label = %ScoreLabel
@onready var best_score_label: Label = %BestScoreLabel
@onready var title: Label = %Title
var score := 0:
	set(new_score):
		score = new_score
		score_label.text = "Score: " + str(score)
var current_level
var next_level
var best_score := true


func _ready() -> void:
	restart_button.pressed.connect(global_signals.start_game.emit.bind(current_level))
	main_menu_button.pressed.connect(global_signals.main_title.emit)
	next_level_button.pressed.connect(global_signals.start_game.emit.bind(next_level))
	
	best_score_label.text = "Best Score: " + str(global_levels.levels[current_level]["best_score"])
	
	if best_score:
		title.text = "CONGRATS!\nBEST SCORE!"
	else:
		title.text = "CONGRATS!"
