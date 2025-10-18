extends CharacterBody2D
const SPEED = 300.0
const ACCEL=2.0
@onready var anim = $Sprite2D
var isAttacking = false
var charInput: Vector2
func get_input():
	charInput.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	charInput.y = Input.get_action_strength("front") - Input.get_action_strength("back")
	return charInput.normalized()

func _process(delta):
	if not isAttacking:
		var playerInput = get_input()
		velocity = lerp(velocity, playerInput * SPEED, delta * ACCEL)
		move_and_slide()
		update_animation(playerInput)
	else:
		move_and_slide()

func update_animation(input: Vector2):
	if(input == Vector2.ZERO and isAttacking == false):
		# idles
		if anim.animation.begins_with("walk_"):
			var dir = anim.animation.replace("walk_", "")
			anim.play("idle_" + dir)
	elif isAttacking == false:
		# walking animations
		if abs(input.x) > abs(input.y):
			# side movement
			anim.flip_h = input.x < 0
			anim.play("walk_side")
		elif input.y > 0:
			anim.play("walk_front")
		else:
			anim.play("walk_back")
	if(Input.is_action_just_pressed("hit")): 
		isAttacking = true; 
		play_hit_animation()
	# if(Input.is_action_just_released("hit")):
		# stop_hitting()

func play_hit_animation():
	anim.play("hit_front")
	isAttacking = false
	
# func stop_hitting():
	# anim.stop()
	# isAttacking = false
