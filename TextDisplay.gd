extends Label

var player = null
export var autostart = false

func _ready():
	start()

func start(txt = ""):
	visible_characters = 0
	$Timer.start()
	if txt != "":
		text = txt

func stop():
	visible_characters = 0
	$Timer.stop()

func _on_Timer_timeout():
	if visible_characters < text.length():
		visible_characters += 1
