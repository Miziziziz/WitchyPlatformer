extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("body_entered", self, "start_race")
	RaceTimer.restart_point = $RestartPoint.global_position

func start_race(body):
	if body.name == "Player":
		RaceTimer.start_race()