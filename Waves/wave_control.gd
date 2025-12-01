extends Control

@onready var launch_button: Button = %LaunchButton
@onready var wave_1_amplitude_slider: HSlider = %Wave1AmplitudeSlider
@onready var wave_1_length_slider: HSlider = %Wave1LengthSlider
@onready var wave_1_offset_slider: HSlider = %Wave1OffsetSlider
@onready var wave_2_amplitude_slider: HSlider = %Wave2AmplitudeSlider
@onready var wave_2_length_slider: HSlider = %Wave2LengthSlider
@onready var wave_2_offset_slider: HSlider = %Wave2OffsetSlider
@onready var wave_3_amplitude_slider: HSlider = %Wave3AmplitudeSlider
@onready var wave_3_length_slider: HSlider = %Wave3LengthSlider
@onready var wave_3_offset_slider: HSlider = %Wave3OffsetSlider
@onready var remove_wave: Button = %RemoveWave
@onready var add_wave: Button = %AddWave
@onready var wave_2_container: VBoxContainer = %Wave2Container
@onready var wave_3_container: VBoxContainer = %Wave3Container
@onready var stop_click_rect: ColorRect = %StopClickRect
@onready var score: Label = %Score
@onready var exit: Button = %Exit
var max_waves_amplitude := 400.0:
	set(new_max_waves_amplitude):
		max_waves_amplitude = new_max_waves_amplitude
		wave_1_amplitude_slider.max_value = max_waves_amplitude
		wave_2_amplitude_slider.max_value = max_waves_amplitude
		wave_3_amplitude_slider.max_value = max_waves_amplitude
var max_wave := 1:
	set(new_max_wave):
		max_wave = new_max_wave
		if new_max_wave == 1:
			add_wave.visible = false
		else:
			add_wave.visible = true
var n_wave_showed := 1:
	set(new_n_wave):
		n_wave_showed = new_n_wave
		if max_wave == 1:
			return
		elif max_wave == 2:
			match n_wave_showed:
				1:
					remove_wave.visible = false
					add_wave.visible = true
					wave_2_container.visible = false
					wave_3_container.visible = false
				2:
					remove_wave.visible = true
					add_wave.visible = false
					wave_2_container.visible = true
					wave_3_container.visible = false
		elif max_wave == 3:
			match n_wave_showed:
				1:
					remove_wave.visible = false
					add_wave.visible = true
					wave_2_container.visible = false
					wave_3_container.visible = false
				2:
					remove_wave.visible = true
					add_wave.visible = true
					wave_2_container.visible = true
					wave_3_container.visible = false
				3:
					remove_wave.visible = true
					add_wave.visible = false
					wave_2_container.visible = true
					wave_3_container.visible = true

func _ready() -> void:
	wave_2_container.visible = false
	wave_3_container.visible = false
	remove_wave.visible = false
	
	add_wave.pressed.connect(func () -> void:
		n_wave_showed += 1
		global_signals.add_wave.emit()
	)
	remove_wave.pressed.connect(func () -> void:
		n_wave_showed -= 1
		global_signals.remove_wave.emit()
	)
	
	launch_button.pressed.connect(func () ->void:
		exit.visible = false
		stop_click_rect.visible = true
		score.visible = true
		global_signals.launch_bullet.emit()
	)
	wave_1_amplitude_slider.value_changed.connect(global_signals.wave_amplitude_changed.emit.bind(1))
	wave_1_length_slider.value_changed.connect(global_signals.wave_length_changed.emit.bind(1))
	wave_1_offset_slider.value_changed.connect(global_signals.wave_offset_changed.emit.bind(1))
	wave_2_amplitude_slider.value_changed.connect(global_signals.wave_amplitude_changed.emit.bind(2))
	wave_2_length_slider.value_changed.connect(global_signals.wave_length_changed.emit.bind(2))
	wave_2_offset_slider.value_changed.connect(global_signals.wave_offset_changed.emit.bind(2))
	wave_3_amplitude_slider.value_changed.connect(global_signals.wave_amplitude_changed.emit.bind(3))
	wave_3_length_slider.value_changed.connect(global_signals.wave_length_changed.emit.bind(3))
	wave_3_offset_slider.value_changed.connect(global_signals.wave_offset_changed.emit.bind(3))
	exit.pressed.connect(global_signals.main_title.emit)


func _process(_delta: float) -> void:
	score.text = "Score: " + str(global_levels.score)
