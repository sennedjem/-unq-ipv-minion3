extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var direcction = "left"
export (int) var run_speed = 60
export (int) var jump_speed = -340
export (int) var gravity = 1200
var rng = RandomNumberGenerator.new()

var active = false
var waiting = false

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	$Timer.autostart = false
	rng.randomize()
	var random = rng.randf()
	if random>0.5:
		print('mas')
		direcction = "right"
		$AnimatedSprite.flip_h = false
	else: 
		print('menos')
		direcction ="left"	
		$AnimatedSprite.flip_h = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = 0
	if(direcction=="right"):
		if(self.position.x>_get_top_right_()):
			waiting = true
			if($Timer.is_stopped()):
				var secs = rng.randf()
				print(secs)
				$Timer.start(secs)
		velocity.x += run_speed
	else:
		if(self.position.x<-33):
			waiting = true
			if($Timer.is_stopped()):
				var secs = rng.randf()
				print(secs)
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
	print('timeout')
	if direcction == "right":
		direcction = "left"
		$AnimatedSprite.flip_h = true
	else:
		direcction = "right"
		$AnimatedSprite.flip_h = false	
