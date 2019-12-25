extends CanvasLayer

export var max_time = 20
var cur_time = 0

var player = null
var restart_point = Vector2()

enum RACE_STATE { NOT_STARTED, STARTED, LOST, WON }
var cur_race_state = RACE_STATE.NOT_STARTED
onready var label = $Label
func _ready():
	$Timer.connect("timeout", self, "inc_time")
	label.hide()

func start_race():
	cur_time = 0
	cur_race_state = RACE_STATE.STARTED
	$Timer.start()
	label.text = "time left: " + str(max_time - cur_time)
	label.show()
	$StartSoundPlayer.play()

func inc_time():
	cur_time += 1
	label.text = "time left: " + str(max_time - cur_time)
	if cur_time >= max_time:
		fail_race()

func fail_race():
	$Timer.stop()
	label.text = "you lost, press 'r' to restart"
	cur_race_state = RACE_STATE.LOST
	$LoseSoundPlayer.play()

func win_race():
	$Timer.stop()
	label.text = "you win"
	cur_race_state = RACE_STATE.WON
	$WinSoundPlayer.play()

func set_player(player_ref):
	player = player_ref

func restart_race():
	if cur_race_state == RACE_STATE.NOT_STARTED:
		return
	label.hide()
	cur_race_state = RACE_STATE.NOT_STARTED
	player.global_position = restart_point
	$RestartSoundPlayer.play()