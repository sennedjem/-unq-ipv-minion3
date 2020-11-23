extends KinematicBody2D

signal pj_step()

# Declare member variables here. Examples:
# var a = 2
var direccion;
export (int) var run_speed = 100
export (int) var jump_speed = -340
export (int) var gravity = 1200

var velocity = Vector2()
var jumping = false
var jumpings = 0
var pasos = 0
var caminando = false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	get_input()
	if jumping:
		$AnimatedSprite.play("salto")
	if jumping and is_on_floor():
		jumping = false
	#if caminando:
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity,Vector2(0, -1))

func jump_power_up():
	jump_speed = -800

func get_input():
	velocity.x = 0
	var right = Input.is_action_pressed('ui_right')
	var left = Input.is_action_pressed('ui_left')
	var jump = Input.is_action_just_pressed('ui_select')
	var shift = Input.is_action_pressed('ui_shift')
	
	if jump and is_on_floor():
		jump(jump_speed)
		caminando = true
	if right:
		$AnimatedSprite.play("camina")
		pasos = pasos + 0.1
		contar_paso()
		velocity.x += run_speed
		$AnimatedSprite.flip_h = false
		caminando = true
	elif left:
		pasos = pasos + 0.1
		contar_paso()
		$AnimatedSprite.play("camina")
		$AnimatedSprite.flip_h = true
		velocity.x -= run_speed	
		caminando = true
	elif shift:
		caminando = true	
	else:
		caminando = false
		$AnimatedSprite.stop()	

func jump(jump_speed):
	$JumpSound.play()
	jumping = true
	velocity.y = jump_speed

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_Timer_timeout():
	$"../KinematicBody2D2/Caja".play('normal')


func _on_KinematicBody2D4_body_entered(body):
	$"../KinematicBody2D4/Caja".play('salto')
	if jumpings>0:
		jump(-700+(-70*jumpings))
	else:	
		jump(-700)
	if jumpings<4:
		jumpings = jumpings +1
	$"../KinematicBody2D4/TimerBox2".start()


func _on_TimerBox2_timeout():
	$"../KinematicBody2D4/Caja".play('normal')


func _on_TimerBox3_timeout():
	$"../KinematicBody2D3/Caja".play('normal')

func contar_paso():
	var oldPasos = pasos
	pasos = pasos + 0.05
	if round(pasos) > round(oldPasos):
		emit_signal("pj_step")

func _on_KinematicBody2D3_body_entered(body):
	salto_normal($"../KinematicBody2D3/Caja",$"../KinematicBody2D3/TimerBox3")


func _on_KinematicBody2D2_body_entered(body):
	salto_normal($"../KinematicBody2D2/Caja",$"../KinematicBody2D2/Timer")

func salto_normal(caja,timer):
	caja.play('salto')
	jump(-700)
	timer.start()


func _on_Caja_body_entered(body):
	if(body.name == "PersonajeJugable"):
		salto_normal($"../Plataformas/plataforma2/Caja/AnimatedSprite",$"../Plataformas/plataforma2/Caja/CajaTimer")


func _on_CajaTimer_timeout():
	$"../Plataformas/plataforma2/Caja/AnimatedSprite".play('normal')
