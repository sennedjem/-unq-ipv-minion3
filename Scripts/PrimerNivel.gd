extends Node2D


signal juego_frenado()
signal juego_activo()
var monedas = 0
var tiempo = 50
var esta_en_final = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$CajaFinal/AnimatedSprite.play("ready")
	$MusicaFondo.play()
	$Timer.start()

func _process(delta):
	check_ending()
	if $PersonajeJugable.caminando:
		_retomar_juego()
	else:
		_frenar_juego()


func _on_Coin_pj_entered():
	monedas = monedas + 1
	$Coin.play()
	$CanvasLayer/Monedas.text = str(monedas)

func _frenar_juego():
	emit_signal("juego_frenado")
	$CanvasLayer/Pasos/clock4.visible = false
	$CanvasLayer/Pasos/clock.visible = true
	$CanvasLayer/Pasos/Cantidad.modulate = Color(1, 1, 1) 
	$Timer.stop()

func _retomar_juego():
	emit_signal("juego_activo")
	$CanvasLayer/Pasos/clock4.visible = true
	$CanvasLayer/Pasos/clock.visible = false
	$CanvasLayer/Pasos/Cantidad.modulate = Color(1, 0, 0) 
	if $Timer.is_stopped():
		$Timer.start()

func _on_PersonajeJugable_pj_step():
	pass

func game_over():
	get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_bottom_body_entered(body):
	game_over()


func _on_CajaFinal_personaje_entro():
	get_tree().change_scene("res://Niveles/SegundoNivel.tscn")
	#esta_en_final = true
	#if !$Success.playing:
	#	$Success.play()
	#	$MusicaFondo.stop()


func _on_CajaFinal_personaje_salio():
	esta_en_final = false

func check_ending():
	if(Input.is_action_just_pressed('ui_accept')):
		get_tree().change_scene("res://Niveles/SegundoNivel.tscn")	


func _on_MusicaFondo_finished():
	$MusicaFondo.play()


func _on_Timer_timeout():
	if(tiempo>1):
		tiempo = tiempo -1
		$CanvasLayer/Pasos/Cantidad.text = str(tiempo)
	else:
		game_over()	
	pass # Replace with function body.
