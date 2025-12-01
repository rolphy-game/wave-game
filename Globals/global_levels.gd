extends Node


var number_of_levels := 7
var score := 10000:
	set(new_score):
		score = maxi(0, new_score)
var levels := {
	1: {
		"unlocked": true,
		"best_score": 0,
		"all_bonuses": false,
	}
}

func _ready() -> void:
	for i in range(2, number_of_levels + 1):
		levels[i] = {
			"unlocked": false,
			"best_score": 0,
			"all_bonuses": false,
		}
