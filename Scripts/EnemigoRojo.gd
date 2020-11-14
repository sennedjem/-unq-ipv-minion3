extends KinematicBody2D


# Declare member variables here. Examples:
# var a = 2
var direcction = "right"
export (int) var run_speed = 60
export (int) var jump_speed = -340
export (int) var gravity = 1200
var active = false

var velocity = Vector2()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = 0
	print(self.position.x)
	if(direcction=="right"):
		if(self.position.x>440):
			direcction="left"
			$AnimatedSprite.flip_h = true
		velocity.x += run_speed
	else:
		if(self.position.x<350):
			direcction="right"
			$AnimatedSprite.flip_h = false
		velocity.x -= run_speed	
	velocity.y += gravity * delta
	if active:
		velocity = move_and_slide(velocity,Vector2(0, -1))
		$AnimatedSprite.play("correr")
	else:
		$AnimatedSprite.play("estatico")


func _on_Level_juego_activo():
	self.active = true


func _on_Level_juego_frenado():
	self.active = false
