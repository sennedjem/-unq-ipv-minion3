extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var monedas = 0
var pasos_restantes = 50


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_pj_entered():
	monedas = monedas + 1
	$CanvasLayer/Monedas.text = str(monedas)


func _on_PersonajeJugable_pj_step():
	if pasos_restantes > 0:
		pasos_restantes = pasos_restantes-1
		$CanvasLayer/Pasos/Cantidad.text = str(pasos_restantes)
	else:
		game_over()	
	print("step")

func game_over():
	get_tree().change_scene("res://GameOver/GameOver.tscn")


func _on_bottom_body_entered(body):
	game_over()
