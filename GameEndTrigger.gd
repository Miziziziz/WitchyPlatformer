extends Area2D

func _ready():
	connect("body_entered", self, "win")

func win(body):
	if body.name == "Player":
		$Friendly2/AnimationPlayer.play("cast_spell")