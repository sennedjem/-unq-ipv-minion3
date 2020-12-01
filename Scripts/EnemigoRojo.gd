extends KinematicBody2D

signal kill_pj()
signal enemigo_murio(body)

var direcction = "left"
export (int) var run_speed = 60
export (int) var jump_speed = -340
export (int) var gravity = 1200
export var left_top_distance = 0
export var right_top_distance = 0
export var personajeJugablePosition = Vector2()
var rng = RandomNumberGenerator.new()
var dead = false
var active = false
var waiting = false
var disparando = false
var state = "normal"
var velocity = Vector2()

func _ready():
	$Timer.autostart = false
	_set_random_direction()

func _set_random_direction():
	rng.randomize()
	var random = rng.randf()
	if random>0.5:
		_turn_right()
	else: 
		_turn_left()

func _process(delta):
	if!dead:
		velocity.x = 0
		_check_pj_proximity()	
		_check_im_on_the_edge()
		_update_velocity_vector(delta)
		_move()
	
func _move():
	if active&&!_pause():
		if(!waiting):
			velocity = move_and_slide(velocity,Vector2(0, -1))
			$AnimatedSprite.play("correr")
		else:
			$AnimatedSprite.play("ocioso")
	else:
		$AnimatedSprite.play("estatico")
	
func _update_velocity_vector(delta):
	if(direcction=="right"):	
			velocity.x += run_speed
	else:
		velocity.x -= run_speed		
	velocity.y += gravity * delta	
			
func _check_im_on_the_edge():
	if(direcction=="right"):
		if(_im_on_right_top()):
			_start_timer()
	else:
		if(_im_on_left_top()):
			_start_timer()

func _start_timer():
	waiting = true
	if($Timer.is_stopped()):
		var secs = rng.randf()
		$Timer.start(secs)

func _im_on_right_top():
	return self.position.x> right_top_distance

func _im_on_left_top():
	return self.position.x< left_top_distance
		
func _check_pj_proximity():
	if(personajeJugablePosition.distance_to(self.global_position)<100 && _same_level_y()):
		state = "atack"
		if !disparando&&!_pause()&&_can_shoot():
			_shoot_bullet() 
	else:
		state = "normal"
		
func _same_level_y():	
	var distanceY = personajeJugablePosition.y - global_position.y
	if(distanceY>0):
		return distanceY < 15
	else:	
		return distanceY> -15
		
func _pause():
	if(personajeJugablePosition.distance_to(self.global_position)<100 && _same_level_y()):	
		return false
	else:
		return ChangeScene.pause
		
func _shoot_bullet():
	if $Timer2.is_stopped():
		$Timer2.start()
	

func _on_Level_juego_activo():
	self.active = true
	$Bala.active = true
	
func _on_Level_juego_frenado():
	self.active = false
	$Bala.active = false

func _turn_left():
	direcction = "left"
	$AnimatedSprite.flip_h = true
	if(!disparando):
		$Bala.position.x = -37

func _turn_right():
	direcction = "right"
	$AnimatedSprite.flip_h = false
	if(!disparando):
		$Bala.position.x = 0

func _can_shoot():
	if(direcction == "right"):
		return !(personajeJugablePosition.x<self.global_position.x)
	else:
		return !(personajeJugablePosition.x>self.global_position.x)

func _check_pj_distance():
	if(direcction == "right"):
		if(personajeJugablePosition.x<self.global_position.x || _im_on_right_top()):
			_turn_left()
	else:
		if(personajeJugablePosition.x>self.global_position.x || _im_on_left_top()):
			_turn_right()
			
func _on_Timer_timeout():
	waiting = false;
	$Timer.stop()
	if direcction == "right":
		_turn_left()
	else:
		_turn_right()

func _enemy_dead():
	dead = true
	$Bala.active = false
	$Bala.visible = false
	$AnimatedSprite.play("muerte")

func _on_Area2D_body_entered(body):
	if(body.name == "PersonajeJugable"):
		_enemy_dead()


func _on_AnimatedSprite_animation_finished():
	if($AnimatedSprite.animation =="muerte"):
		$AnimatedSprite.stop()
		$AnimatedSprite.set_animation("muerte")
		$AnimatedSprite.set_frame(6)
		queue_free()
		emit_signal("enemigo_murio", self)


func _on_Bala_body_entered(body):
	if(body.name == "PersonajeJugable"&& !dead):
		emit_signal("kill_pj")


func _on_Timer2_timeout():
	disparando = true
	$Bala.visible = true
	$Bala.disparando = true
	$Bala.player_position = personajeJugablePosition
	$Timer2.stop()
