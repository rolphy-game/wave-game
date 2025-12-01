class_name Bullet extends Area2D

@onready var particles_dead: GPUParticles2D = %ParticlesDead
@onready var particles_win: GPUParticles2D = %ParticlesWin
@onready var particles_run: GPUParticles2D = %ParticlesRun
@onready var sprite: Sprite2D = %Sprite2D
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = %VisibleOnScreenNotifier2D
@onready var explosion: AudioStreamPlayer = %Explosion
@onready var win_sound: AudioStreamPlayer = %WinSound


func _ready() -> void:
	area_entered.connect(_on_area_entered)
	visible_on_screen_notifier_2d.screen_exited.connect(_die)


func _die() -> void:
	explosion.play()
	global_signals.die.emit()
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	sprite.visible = false
	particles_run.emitting = false
	particles_dead.emitting = true


func _win() -> void:
	win_sound.play()
	global_signals.end_level.emit()
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	sprite.visible = false
	particles_run.emitting = false
	particles_win.emitting = true


func _on_area_entered(area: Area2D) -> void:
	if area is Ending:
		global_position = area.global_position
		area.bullet_touch()
		_win()
	elif area is Bonus:
		area.bullet_touched()
	elif area is LaserWall:
		_die()
