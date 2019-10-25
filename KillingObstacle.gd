extends "res://AbstractObstacle.gd"

func on_collision_with_player(player):
	player.do_kill()
