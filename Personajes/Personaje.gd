extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var direccion;
export (int) var run_speed = 100
export (int) var jump_speed = -340
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	get_input()
	
	velocity.y += gravity * delta
	if jumping:
		$AnimatedSprite.play("salto")
	if jumping and is_on_floor():
		jumping = false
	velocity = move_and_slide(velocity,Vector2(0, -1))


func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')

	if jump and is_on_floor():
		jump(jump_speed)
	if right:
		$AnimatedSprite.play("camina")
		velocity.x += run_speed
		$AnimatedSprite.flip_h = false
	elif left:
		$AnimatedSprite.play("camina")
		$AnimatedSprite.flip_h = true
		velocity.x -= run_speed	
	else:
		$AnimatedSprite.stop()	
	
func _input(ev):
	pass

func jump(jump_speed):
	jumping = true
	velocity.y = jump_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_KinematicBody2D_body_entered(body):
	print('jajaj perri')
	#"mas/StaticBody2D4/KinematicBody2D".
	$"../KinematicBody2D2/AnimatedSprite".play('salto')
	jump(-700)
	$"../KinematicBody2D2/Timer".start()
	
	pass # Replace with function body.


func _on_Timer_timeout():
	$"../KinematicBody2D2/AnimatedSprite".play('normal')
