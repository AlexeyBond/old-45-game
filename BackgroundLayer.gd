extends Node2D

export(String, DIR) var directory = 'res://test';
export(String, FILE, "*.tscn") var start_scene;
export(String) var prefix;
export(float) var scroll_speed;

onready var player = get_node('../player')

var scene_ress = []

func get_part_scenes():
	var dir = Directory.new()
	dir.open(directory)

	var scenes = [];
	
	dir.list_dir_begin()
	var re = RegEx.new()
	re.compile(prefix + '.*\\.tscn$')

	while true:
		match dir.get_next():
			'': break
			var fn:
				if re.search(fn):
					print('Found: ', fn)
					scenes.append(load(directory + '/' + fn))

	return scenes

class Part:
	extends ParallaxBackground
	var scroll_speed
	var scroll_size
	signal scroll_end
	var scrolled = false
	
	func _init(scene_node):
		var parallax_layer = ParallaxLayer.new()
		parallax_layer.add_child(scene_node)

		self.scroll_size = 1921 # TODO
		self.scroll_offset.x = 1921
		
		self.add_child(parallax_layer)

	func _process(delta):
		var player = self.get_node('../../player')
		var d_off = delta * scroll_speed * player.game_speed
		self.scroll_offset.x -= d_off
		if scroll_offset.x < -(scroll_size - 1920):
			if !scrolled:
				emit_signal("scroll_end")
				scrolled = true
			if scroll_offset.x < -scroll_size:
				get_parent().remove_child(self)

var last_part_res

func spawn_part(scene_res):
	var part = Part.new(scene_res.instance())
	part.scroll_speed = scroll_speed
	part.connect('scroll_end', self, 'spawn_next_part')
	last_part_res = scene_res
	add_child(part)

func spawn_next_part():
	var s = scene_ress.duplicate()
	s.remove(s.find(last_part_res))
	spawn_part(s[randi() % s.size()])

func _ready():
	scene_ress = get_part_scenes()
	spawn_part(load(start_scene))

func _process(delta):
	pass
