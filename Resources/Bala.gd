extends Area2D


# Declare member variables here. Examples:
var player_position = 2
var active = false
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if(visible && active):
		var velocidad = 70
		var direccion = player_position - global_position
		position += direccion.normalized() * (velocidad ) * delta 
		if(global_position.distance_to(player_position)<2):
			$Timer.start()
			self.visible = false
			self.active = false
			self.position.y = 0
			if($"..".direcction =="right"):
				self.position.x = 0
			else:
				self.position.x = -37 	
			


func _on_Timer_timeout():
	$Timer.stop()
	print('jaja')
	$"..".disparando = false
