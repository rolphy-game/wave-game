@tool
class_name Level extends Node2D

@export_range(1, 3) var max_wave := 1
@export var max_waves_amplitude := 400
var current_level_bonuses := 0
var current_level_number: int
var next_level: Dictionary
@onready var wave_control: Control = %WaveControl
@onready var background: ColorRect = %Background
@onready var wave_creator: Node2D = %WaveCreator

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	wave_creator.global_position.x += 50
	global_levels.score = 10000
	wave_control.max_wave = max_wave
	wave_control.max_waves_amplitude = max_waves_amplitude
	var current_level: Dictionary = global_levels.levels[current_level_number]
	if current_level_number + 1 <= global_levels.levels.size():
		next_level = global_levels.levels[current_level_number + 1]
	
	global_signals.bonus_touched.connect(func (_bonus) -> void:
		current_level_bonuses += 1
	)
	
	global_signals.end_level.connect(func () -> void:
		if current_level_bonuses == 3:
			current_level["all_bonuses"] = true
		if next_level:
			next_level["unlocked"] = true
	)
	
	global_signals.launch_bullet.connect(func () -> void:
		var tween := create_tween()
		tween.tween_property(background, "color", Color.BLACK, 1.5)
	)
