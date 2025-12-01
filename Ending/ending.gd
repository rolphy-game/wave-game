class_name Ending extends Area2D

const ENDING_WAVE = preload("uid://45nkkvng55gk")
@onready var timer: Timer = %Timer
@onready var sprite: Sprite2D = %Sprite


func _ready() -> void:
	timer.timeout.connect(_create_aureole)


func bullet_touch() -> void:
	sprite.visible = false
	timer.one_shot = true


func _create_aureole() -> void:
	var aureole = Sprite2D.new()
	aureole.texture = ENDING_WAVE
	aureole.scale = Vector2.ZERO
	add_child(aureole)
	
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(aureole, "scale", Vector2.ONE, 2.0)
	tween.tween_property(aureole, "modulate:a", 0.0, 2.0)
	await tween.finished
	aureole.queue_free()
