extends Node2D

var player = null
var spot_range = 70
export var text = ""

var displaying = false

func _process(delta):
	if is_player_in_range():
		if !displaying:
			$TextDisplay.start(text)
			displaying = true
	else:
		displaying = false
		$TextDisplay.stop()
		

func set_player(player_ref):
	player = player_ref

func is_player_in_range():
	if player == null:
		return false
	return global_position.distance_squared_to(player.global_position) < spot_range * spot_range

func win():
	player.win()