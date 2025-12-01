@tool
class_name Wave extends Resource


@export_range(100, 500, 1) var wave_length := 200:
	set(new_wave_length):
		wave_length = new_wave_length
		emit_changed()
@export_range(30, 400, 1) var wave_amplitude := 100:
	set(new_wave_amplitude):
		wave_amplitude = new_wave_amplitude
		emit_changed()
@export_range(0, 30, 0.1) var wave_offset := 0.0:
	set(new_wave_offset):
		wave_offset = new_wave_offset
		emit_changed()
