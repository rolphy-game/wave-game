@tool
extends Node2D


const _BULLET = preload("uid://ulsvbodt2oho")

@export var process := false
@export var bullet_speed := 600
@export_category("Waves")
@export var waves: Array[Wave] = [Wave.new()]: set = _waves_array_change
var bullet_can_move := false
var can_launch_bullet := true
var wave_can_move := true
var start_score := 10000
@onready var wave_start: Marker2D = %WaveStart
@onready var wave_line: Line2D = %WaveLine
@onready var wave_line_2: Line2D = %WaveLine2
@onready var wave_line_3: Line2D = %WaveLine3
@onready var wave_path: Path2D = %WavePath
@onready var wave_path_follow: PathFollow2D = %WavePathFollow
@onready var charge: GPUParticles2D = $Charge
@onready var laser: Sprite2D = %Laser
@onready var launch_sound: AudioStreamPlayer = %LaunchSound
@onready var load_sound: AudioStreamPlayer = %Load


func _ready() -> void:
	if !Engine.is_editor_hint():
		global_signals.launch_bullet.connect(launch_bullet)
		global_signals.add_wave.connect(add_new_wave)
		global_signals.remove_wave.connect(remove_wave)
		global_signals.die.connect(func () -> void:
			bullet_can_move = false
		)
		global_signals.end_level.connect(func () -> void:
			bullet_can_move = false
		)
		global_signals.wave_amplitude_changed.connect(func (value, wave) -> void:
			waves[wave - 1].wave_amplitude = value
		)
		global_signals.wave_length_changed.connect(func (value, wave) -> void:
			waves[wave - 1].wave_length = value
		)
		global_signals.wave_offset_changed.connect(func (value, wave) -> void:
			waves[wave - 1].wave_offset = - value
		)
	for i in waves:
		i.changed.connect(_waves_array_change.bind(waves))
	waves = waves
	reset_wave()


func _process(delta: float) -> void:
	if wave_can_move and process:
		waves[0].wave_offset -= 2 * delta
	
	if bullet_can_move:
		wave_path_follow.progress += bullet_speed * delta
		global_levels.score = start_score - floori(wave_path_follow.progress)


func _waves_array_change(new_waves: Array[Wave]) -> void:
	if new_waves.size() == 0 or !wave_path:
		return
	
	for idx in new_waves.size():
		if new_waves[idx] == null:
			new_waves[idx] = Wave.new()
			new_waves[idx].changed.connect(_waves_array_update)
	
	waves = new_waves
	
	var waves_y_pos: Array[Array] = []
	for wave in waves:
		var wave_pos: Array[float] = _create_wave_y_pos(wave.wave_length, wave.wave_amplitude, wave.wave_offset)
		waves_y_pos.append(wave_pos)
	if get_parent() is SubViewport:
		_draw_separate_waves(waves_y_pos)
	else:
		_sum_waves(waves_y_pos)


func _create_wave_y_pos(length: int, amplitude: float, offset: float) -> Array[float]:
	var pos_y: Array[float] = []
	
	for pos_x in range(0, 2300, 1):
		if pos_x != 0:
			offset += 2.0 * PI / length
		offset = wrap(offset, 0.0, 2 * PI)
		pos_y.append(sin(offset) * amplitude)
	
	return pos_y


func _sum_waves(waves_to_sum: Array[Array]) -> void:
	if waves_to_sum.size() == 1:
		_draw_wave(waves_to_sum[0])
	
	var wave_summed: Array = waves_to_sum[0]
	for wave_idx in range(1, waves_to_sum.size()):
		var wave: Array = waves_to_sum[wave_idx]
		for idx in wave.size():
			wave_summed[idx] += wave[idx]
	_draw_wave(wave_summed)


func _draw_separate_waves(waves_to_draw) -> void:
	wave_line.clear_points()
	wave_line_2.clear_points()
	wave_line_3.clear_points()
	_draw_wave(waves_to_draw[0])
	if waves_to_draw.size() >= 2:
		var points_array = waves_to_draw[1]
		for pos_x in range(0, points_array.size(), 1):
			wave_line_2.add_point(Vector2(pos_x, points_array[pos_x]))
	if waves_to_draw.size() >= 3:
		var points_array = waves_to_draw[2]
		for pos_x in range(0, points_array.size(), 1):
			wave_line_3.add_point(Vector2(pos_x, points_array[pos_x]))


func _draw_wave(points_array: Array[float]) -> void:
	wave_line.clear_points()
	for pos_x in range(0, points_array.size(), 1):
		wave_line.add_point(Vector2(pos_x, points_array[pos_x]))
		if pos_x == 0:
			laser.position = wave_line.get_point_position(pos_x)
		if pos_x == 1:
			laser.look_at(to_global(wave_line.get_point_position(pos_x)))


func _waves_array_update() -> void:
	waves = waves


func launch_bullet() -> void:
	if !can_launch_bullet or get_parent() is SubViewport:
		return
	
	charge.rotation = laser.rotation
	charge.emitting = true
	
	can_launch_bullet = false
	wave_path.curve.clear_points()
	for i in range(0, wave_line.get_point_count(), 2):
		wave_path.curve.add_point(wave_line.get_point_position(i))
	
	var bullet: Bullet = _BULLET.instantiate()
	wave_path_follow.add_child(bullet)
	bullet.particles_run.emitting = false
	wave_line.visible = false
	wave_can_move = false
	
	charge.global_position = bullet.global_position
	
	load_sound.play()
	await get_tree().create_timer(1.5).timeout
	charge.emitting = false
	await get_tree().create_timer(0.2).timeout
	
	launch_sound.play()
	bullet.particles_run.emitting = true
	bullet_can_move = true


func reset_wave() -> void:
	for child in wave_path_follow.get_children():
		child.queue_free()
	wave_path_follow.progress = 0.0
	wave_line.visible = true
	bullet_can_move = false
	wave_can_move = true
	can_launch_bullet = true


func add_new_wave() -> void:
	waves.append(Wave.new())
	waves.get(waves.size() - 1).changed.connect(_waves_array_change.bind(waves))
	_waves_array_change(waves)


func remove_wave() -> void:
	waves.resize(waves.size() - 1)
	_waves_array_change(waves)
