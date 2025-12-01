@tool
class_name Bonus extends Area2D

const FIRST_BONUS = preload("uid://dqawi2jsuesll")
const SECOND_BONUS = preload("uid://clm5sqryelpad")
const THIRD_BONUS = preload("uid://cau8oobv4hw8f")

@onready var sprite: Sprite2D = %Sprite2D
@onready var collect: AudioStreamPlayer = %Collect
var end_position_x := 0.0
@export_enum("First", "Second", "Third") var bonus_number:= "First"


func _ready() -> void:
	_change_letter(bonus_number)


func _change_letter(new_bonus) -> void:
	if !sprite:
		return
	bonus_number = new_bonus

	match new_bonus:
		"First":
			sprite.texture = FIRST_BONUS
		"Second":
			sprite.texture = SECOND_BONUS
		"Third":
			sprite.texture = THIRD_BONUS


func bullet_touched() -> void:
	collect.play()
	global_signals.bonus_touched.emit(bonus_number)
	match bonus_number:
		"First":
			end_position_x = get_viewport_rect().size.x / 2.0 - 100.0
		"Second":
			end_position_x = get_viewport_rect().size.x / 2.0
		"Third":
			end_position_x = get_viewport_rect().size.x / 2.0 + 100.0
	
	var tween_pos := create_tween()
	tween_pos.tween_property(self, "global_position", Vector2(end_position_x, get_viewport_rect().size.y - 250), 1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	var tween_scale := create_tween()
	tween_scale.tween_property(self, "scale", Vector2(2.0, 2.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween_scale.tween_property(self, "scale", Vector2(1.0, 1.0), 0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
