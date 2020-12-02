extends Node2D


signal juego_frenado()
signal juego_activo()
var tiempo = 50
var esta_en_final = false
var enemigos = {}
var keys_collected = 0
var puede_avanzar = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Plataformas/StaticBody2D6/EnemigoRojo1.left_top_distance = 58
	$Plataformas/StaticBody2D6/EnemigoRojo1.right_top_distance = 178
	$Plataformas/StaticBody2D3/EnemigoRojo2.left_top_distance = 353
	$Plataformas/StaticBody2D3/EnemigoRojo2.right_top_distance = 503
	$Plataformas/StaticBody2D7/EnemigoRojo3.left_top_distance = 371
	$Plataformas/StaticBody2D7/EnemigoRojo3.right_top_distance = 527
	$Plataformas/StaticBody2D5/EnemigoRojo4.left_top_distance = 747
	$Plataformas/StaticBody2D5/EnemigoRojo4.right_top_distance = 895
	
	enemigos = {
		"EnemigoRojo1": $Plataformas/StaticBody2D6/EnemigoRojo1,
		"EnemigoRojo2": $Plataformas/StaticBody2D3/EnemigoRojo2,
		"EnemigoRojo3": $Plataformas/StaticBody2D7/EnemigoRojo3,
		"EnemigoRojo4": $Plataformas/StaticBody2D5/EnemigoRojo4
	}
	$MusicaFondo.play()
	$Timer.start()

func _process(delta):
	set_position_to_enemies()
	#check_ending()
	if (keys_collected == 10):
		$CajaFinal/AnimatedSprite.play("fin")
		puede_avanzar = true
	elif (keys_collected < 10):
		$CajaFinal/AnimatedSprite.play("mitad")
	if $PersonajeJugable.caminando:
		_retomar_juego()
	else:
		_frenar_juego()


func _on_Coin_pj_entered():
	keys_collected = keys_collected + 1
	$Coin.play()
	$CanvasLayer/Monedas.text = str(keys_collected)

func _frenar_juego():
	emit_signal("juego_frenado")
	$CanvasLayer/Pasos/clock4.visible = true
	$CanvasLayer/Pasos/clock.visible = false
	$CanvasLayer/Pasos/Cantidad.modulate = Color(1, 0, 0) 
	$Timer.stop()

func _retomar_juego():
	emit_signal("juego_activo")
	$CanvasLayer/Pasos/clock4.visible = false
	$CanvasLayer/Pasos/clock.visible = true
	$CanvasLayer/Pasos/Cantidad.modulate = Color(1, 1, 1) 
	if $Timer.is_stopped():
		$Timer.start()

func _on_PersonajeJugable_pj_step():
	pass

func game_over():
	ChangeScene.lastLevel = "res://Niveles/PrimerNivel.tscn"
	get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_bottom_body_entered(body):
	game_over()


func _on_CajaFinal_personaje_entro():
	if puede_avanzar:
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

func _on_enemigo_murio(body):
	enemigos.erase(body.name)

func set_position_to_enemies():
	for enemigo in enemigos.values():
		if enemigo != null:
			enemigo.personajeJugablePosition = $PersonajeJugable.global_position


func _on_EnemigoRojo_kill_pj():
	game_over()
