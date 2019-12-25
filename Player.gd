extends KinematicBody2D

export var move_speed = 200
export var gravity = 20
export var less_gravity = 10
export var jump_force = 400
var velo = Vector2()
var drag = 0.3

const jump_buffer = 0.08
var time_pressed_jump = 0.0
var time_left_ground = 0.0
var last_grounded = false

var facing_right = true

onready var anim_player = $AnimationPlayer

var being_knocked_back = false
var knockback_time = 0.3
var cur_knockback_time = 0.0
var knockback_vec = Vector2()

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	get_tree().call_group("need_player_ref", "set_player", self)

func _process(delta):
	if Input.is_action_pressed("exit"):
		get_tree().quit()
	if Input.is_action_pressed("restart"):
		RaceTimer.restart_race()


func _physics_process(delta):
	if being_knocked_back:
		move_and_slide(knockback_vec, Vector2.UP)
		cur_knockback_time += delta
		if cur_knockback_time > knockback_time:
			being_knocked_back = 0.0
			velo = knockback_vec
	else:
		calc_regular_movement(delta)

func calc_regular_movement(delta):
	var move_vec = Vector2()
	if Input.is_action_pressed("move_left"):
		move_vec.x -= 1
	if Input.is_action_pressed("move_right"):
		move_vec.x += 1
	
	velo += move_vec * move_speed - drag * Vector2(velo.x, 0)
	
	var cur_grounded = is_on_floor()
	if !cur_grounded and last_grounded:
		time_left_ground = get_cur_time()
	
	#var will_jump = false
	var pressed_jump = Input.is_action_just_pressed("jump")
	
	if pressed_jump:
		time_pressed_jump = get_cur_time()
	
	if (pressed_jump and cur_grounded):
		jump()
	elif (!last_grounded and cur_grounded and get_cur_time() - time_pressed_jump < jump_buffer):
		jump()
	elif pressed_jump and get_cur_time() - time_left_ground < jump_buffer:
		jump()
	
	var holding_jump = Input.is_action_pressed("jump")
	if holding_jump:
		velo.y += less_gravity
	else:
		velo.y += gravity
	
	if cur_grounded and velo.y > 10:
		velo.y = 10
	
	velo = move_and_slide(velo, Vector2.UP)
	
	if move_vec.x > 0.0 and !facing_right:
		flip()
	elif move_vec.x < 0.0 and facing_right:
		flip()
	
	$JumpParticles.emitting = false
	if cur_grounded:
		if move_vec == Vector2():
			play_anim("idle")
		else:
			play_anim("run")
	else:
		if !holding_jump:
			play_anim("fall")
		else:
			play_anim("jump")
			$JumpParticles.emitting = true
	
	
	last_grounded = cur_grounded

func jump():
	velo.y = -jump_force

func get_cur_time():
	return OS.get_ticks_msec() / 1000.0

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func knockback(dir, power):
	cur_knockback_time = 0.0
	being_knocked_back = true
	knockback_vec = dir * power

var won = false
func win():
	if won:
		return
	$WinSoundPlayer.play()
	won = true
	$Sprite.texture = load("res://spritesheets/Witchcraft_spr_1.png")
	$WinParticles.emitting = true
	jump_force = 450
	move_speed = 80