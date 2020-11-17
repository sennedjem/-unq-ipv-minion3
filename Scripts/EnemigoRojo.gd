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
var velocity = Vector2()

func _ready():
	$Timer.autostart = false
	rng.randomize()
	var random = rng.randf()
	if random>0.5:
		direcction = "right"
		$AnimatedSprite.flip_h = false
		$Bala.position.x = -37
	else: 
		direcction ="left"	
		$AnimatedSprite.flip_h = true

func _process(delta):
	if!dead:
		velocity.x = 0
		if(personajeJugablePosition.distance_to(self.global_position)<100):
			if !disparando:
				disparando = true
				$Bala.visible = true
				$Bala.player_position = personajeJugablePosition
			$Bala.active = active	
		if(direcction=="right"):
			if(self.position.x> right_top_distance):
				waiting = true
				if($Timer.is_stopped()):
					var secs = rng.randf()
					$Timer.start(secs)
			velocity.x += run_speed
		else:
			if(self.position.x<left_top_distance):
				waiting = true
				if($Timer.is_stopped()):
					var secs = rng.randf()
					$Timer.start(secs)
			velocity.x -= run_speed	
		velocity.y += gravity * delta
		if active:
			if(!waiting):
				velocity = move_and_slide(velocity,Vector2(0, -1))
				$AnimatedSprite.play("correr")
			else:
				$AnimatedSprite.play("ocioso")
		else:
			$AnimatedSprite.play("estatico")


func _on_Level_juego_activo():
	self.active = true

func _get_top_right_():
	if($"../Caja" || $"../CajaFinal"):
		return 20
	return 33
	
func _on_Level_juego_frenado():
	self.active = false


func _on_Timer_timeout():
	waiting = false;
	$Timer.stop()
	if direcction == "right":
		direcction = "left"
		$Bala.position.x = -37
		$AnimatedSprite.flip_h = true
	else:
		direcction = "right"
		$AnimatedSprite.flip_h = false	


func _on_Area2D_body_entered(body):
	print(body.name)
	if(body.name == "PersonajeJugable"):
		dead = true
		$Bala.active = false
		$Bala.visible = false
		$AnimatedSprite.play("muerte")


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
