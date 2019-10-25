extends KinematicBody2D

onready var player = get_node('../player')

const MOVE_SPEED = 300
var SPAWN_X = 2400
const DELETE_X = -400

func _ready():
	self.transform.origin.x = SPAWN_X

func _physics_process(delta):
	var collisions = self.move_and_collide(Vector2.LEFT * delta * MOVE_SPEED * player.game_speed)
	if collisions:
		self.on_collision_with_player(player)

	if self.transform.get_origin().x < DELETE_X:
		get_parent().remove_child(self)

func on_collision_with_player(player):
	pass
