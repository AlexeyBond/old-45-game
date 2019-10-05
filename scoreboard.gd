extends Node

onready var textNode = get_node('text')

signal current_score

var current_score = 0

func update_current(score):
	current_score += score
	textNode.text = '%d' % current_score

func gameover():
	pass

func get_top():
	return [1, 2, 3, 4, 5]
