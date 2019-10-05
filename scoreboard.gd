extends Node

onready var textNode = get_node('text')

var current_score = 0

var all_scores = []
var top_scores

func read_scores():
	var file = File.new()
	file.open('user://catscores.json', File.READ)
	var pr = JSON.parse(file.get_as_text())
	if pr.result:
		all_scores = pr.result
	else:
		all_scores = []
	file.close()

func write_scores():
	var file = File.new()
	file.open('user://catscores.json', File.WRITE)
	file.store_string(JSON.print(all_scores))
	file.close()

func refresh_top():
	var s = all_scores.duplicate()
	s.sort()
	s.invert()
	var ss = []
	# fck ths sht
	for i in range(5):
		if s.size() > i:
			ss.append(s[i])
	top_scores = ss

	var msg = ''
	for r in ss:
		msg += ' %d\n' % r
	textNode.text = msg

func update_current(score):
	current_score += score
	textNode.text = ' %d' % current_score

func gameover():
	all_scores.append(current_score)
	current_score = 0
	write_scores()

func get_top():
	return [1, 2, 3, 4, 5]

func _ready():
	read_scores()
	refresh_top()
