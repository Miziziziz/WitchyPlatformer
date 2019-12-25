extends KinematicBody2D

var move_speed = 20
var player = null
var facing_right = true
onready var anim_player = $AnimationPlayer
export var attack_range = 50
export var knockback_force = 300


func _physics_process(delta):
	var move_dir = 0
	if facing_right:
		move_dir = 1
		
		if !$RayCastBotRight.is_colliding() or $RayCastRight.is_colliding():
			flip()
			move_dir = -1
	else:
		move_dir = -1
		if !$RayCastBotLeft.is_colliding() or $RayCastLeft.is_colliding():
			flip()
			move_dir = 1
	
	if can_see_player():
		play_anim("attack")
		if player.global_position.x < global_position.x:
			if facing_right:
				flip()
		else:
			if !facing_right:
				flip()
	else:
		move_and_collide(Vector2(move_dir * move_speed * delta, 0.0))
		if move_dir == 0:
			play_anim("idle")
		else:
			play_anim("run")

func is_player_in_range():
	if player == null:
		return false
	return global_position.distance_squared_to(player.global_position) < attack_range * attack_range

func can_see_player():
	if !is_player_in_range():
		return
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_ray(global_position + Vector2.UP * 10, player.global_position + Vector2.UP * 10, [self], 1)
	if result:
		return false
	return true

func attack():
	if player != null and is_player_in_range():
		player.knockback((player.global_position - global_position).normalized(), knockback_force)
		$AttackSoundPlayer.play()

func play_anim(anim):
	if anim_player.current_animation == anim:
		return
	anim_player.play(anim)

func set_player(player_ref):
	player = player_ref

func flip():
	$Sprite.flip_h = !$Sprite.flip_h
	facing_right = !facing_right