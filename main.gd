extends Node2D

const TITLE = preload("uid://dh3y68tvgu2t6")
const WIN_SCREEN = preload("uid://bwqw45rkcari1")
const WAVE_CONTROL = preload("uid://df2uipwqakwwc")
const DEAD_SCREEN = preload("uid://bv242dl3n4dyh")
const LEVELS = preload("uid://d4naducceadap")

@onready var game: Node2D = %Game
@onready var ui: Control = %UI
var current_level_number: int
var next_level_number: int

func _ready() -> void:
	global_signals.main_title.connect(func () -> void:
		Music.select.play()
		_play_music(Music.title)
		Transition.transition()
		await Transition.finished_middle_transition
		_clean_game_and_ui()
		ui.add_child(TITLE.instantiate())
	)
	global_signals.start_game.connect(func (level_number: int) -> void:
		Music.select.play()
		_play_music(Music.game)
		Transition.transition()
		await Transition.finished_middle_transition
		_clean_game_and_ui()
		current_level_number = level_number
		next_level_number = level_number + 1
		var current_level_scene = load("res://Levels/level_" + str(level_number) + ".tscn").instantiate()
		current_level_scene.current_level_number = level_number
		game.add_child(current_level_scene)
	)
	global_signals.level_menu.connect(func () -> void:
		Music.select.play()
		_play_music(Music.title)
		Transition.transition()
		await Transition.finished_middle_transition
		_clean_game_and_ui()
		ui.add_child(LEVELS.instantiate())
	)
	global_signals.end_level.connect(func () -> void:
		var win_screen_instance = WIN_SCREEN.instantiate()
		
		if global_levels.score > global_levels.levels[current_level_number]["best_score"]:
			global_levels.levels[current_level_number]["best_score"] = global_levels.score
			win_screen_instance.best_score = true
		else:
			win_screen_instance.best_score = false
		
		win_screen_instance.current_level = current_level_number
		win_screen_instance.next_level = next_level_number
		ui.add_child(win_screen_instance)
		win_screen_instance.score = global_levels.score
	)
	global_signals.die.connect(func () -> void:
		var dead_screen_instance = DEAD_SCREEN.instantiate()
		dead_screen_instance.current_level = current_level_number
		ui.add_child(dead_screen_instance)
	)


func _clean_game_and_ui() -> void:
	for child in game.get_children() + ui.get_children():
		child.queue_free()


func _play_music(music: AudioStreamPlayer) -> void:
	if music.name == "Title":
		if Music.title.has_stream_playback():
			return
		else:
			var tween1 := create_tween()
			tween1.tween_property(Music.game, "volume_db", -80.0, 1.0)
			await  tween1.finished
			Music.game.stop()
			Music.title.volume_db = -80.0
			Music.title.play()
			var tween2 := create_tween()
			tween2.tween_property(Music.title, "volume_db", 0.0, 0.5)
	elif music.name == "Game":
		if Music.game.has_stream_playback():
			return
		else:
			var tween1 := create_tween()
			tween1.tween_property(Music.title, "volume_db", -80.0, 1.0)
			await  tween1.finished
			Music.title.stop()
			Music.game.volume_db = -80.0
			Music.game.play()
			var tween2 := create_tween()
			tween2.tween_property(Music.game, "volume_db", 0.0, 0.5)
