extends Control

const LEVEL_BUTTON = preload("uid://dlp1osufht03l")

@onready var grid_container: GridContainer = %GridContainer
@onready var return_button: Button = %ReturnButton

func _ready() -> void:
	return_button.pressed.connect(global_signals.main_title.emit)
	
	for i in grid_container.get_children():
		i.queue_free()
	
	_add_levels_buttons()


func _add_levels_buttons() -> void:
	for level in global_levels.levels:
		var level_button: LevelButton = LEVEL_BUTTON.instantiate()
		grid_container.add_child(level_button)
		level_button.button.text = str(level)
		
		if global_levels.levels[level]["all_bonuses"]:
			level_button.all_bonuses.visible = true
		else:
			level_button.all_bonuses.visible = false
		
		if global_levels.levels[level]["unlocked"]:
			level_button.button.disabled = false
		else:
			level_button.button.disabled = true
		
		level_button.score.text = str(global_levels.levels[level]["best_score"])
		
		level_button.button.pressed.connect(global_signals.start_game.emit.bind(level))
