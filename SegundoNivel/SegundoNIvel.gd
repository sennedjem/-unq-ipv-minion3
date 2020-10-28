extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var monedas = 0
var pasos_restantes = 50
var esta_en_final = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CajaFinal/AnimatedSprite.play("ready")

func _process(delta):
	check_ending()

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

func game_over():
	get_tree().change_scene("res://GameOver/GameOver.tscn")


func _on_bottom_body_entered(body):
	game_over()


func _on_CajaFinal_personaje_entro():
	esta_en_final = true


func _on_CajaFinal_personaje_salio():
	esta_en_final = false

func check_ending():
	if(Input.is_action_just_pressed('ui_accept')):
		get_tree().change_scene("res://Nivel 3.tscn")	
