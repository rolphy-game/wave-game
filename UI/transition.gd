extends CanvasLayer


signal finished_middle_transition

@onready var sprite_2d: Sprite2D = %Sprite2D
@onready var animation_player: AnimationPlayer = %AnimationPlayer


func _ready() -> void:
	sprite_2d.position.x = -2500.0
	animation_player.animation_finished.connect(_on_animation_finished)


func transition() -> void:
	animation_player.play("in")


func _on_animation_finished(anim_name) -> void:
	if anim_name == "in":
		finished_middle_transition.emit()
		animation_player.play("out")
	elif anim_name == "out":
		sprite_2d.position.x = -2500.0
