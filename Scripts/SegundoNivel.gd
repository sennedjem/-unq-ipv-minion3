extends Node2D

var coins_total = 14
var coins_collected = 0
var seconds = 60
var puede_avanzar = false
var esta_en_final = false
signal juego_frenado()
signal juego_activo()
var enemigos = {}

func _ready():
	$MusicaFondo.play()
	
	$"Bordes y Plataformas/Plataformas/plataforma4/EnemigoRojo1".left_top_distance = -25
	$"Bordes y Plataformas/Plataformas/plataforma4/EnemigoRojo1".right_top_distance = 194
	$"Bordes y Plataformas/Plataforma Alta/EnemigoRojo2".right_top_distance = 95
	$"Bordes y Plataformas/Plataforma Alta/EnemigoRojo2".left_top_distance = -25
	
	enemigos = {
		"EnemigoRojo1" : $"Bordes y Plataformas/Plataformas/plataforma4/EnemigoRojo1",
		"EnemigoRojo2" : $"Bordes y Plataformas/Plataforma Alta/EnemigoRojo2"
	}
func _process(delta):
	set_position_to_enemies()
	check_distance_caja()
	check_ending()
	if (coins_collected == 14):
		$"Caja Final/AnimatedSprite".play("fin")
		puede_avanzar = true
	elif (coins_collected >= 7):
		$"Caja Final/AnimatedSprite".play("mitad")
	if $PersonajeJugable.caminando:
		_retomar_juego()
	else:
		_frenar_juego()
		
func _frenar_juego():
	emit_signal("juego_frenado")	
	$CanvasLayer/Timer/clock4.visible = true
	$CanvasLayer/Timer/clock.visible = false
	$CanvasLayer/Timer.modulate = Color(1, 0, 0) 		
	$Timer.stop()

func _retomar_juego():
	emit_signal("juego_activo")	
	$CanvasLayer/Timer/clock4.visible = false
	$CanvasLayer/Timer/clock.visible = true
	$CanvasLayer/Timer.modulate = Color(1, 1, 1) 	
	if $Timer.is_stopped():
		$Timer.start()		

func check_distance_caja():
	var distanceCajaPj = $PersonajeJugable.position.distance_to($"Bordes y Plataformas/Techo con gancho/Caja".position)
	var distanceCajaPlataforma = $"Bordes y Plataformas/Techo con gancho/Caja".position.distance_to($"Bordes y Plataformas/Plataforma Alta/StaticBody2D".position)
	
	if (distanceCajaPlataforma > 405):
		$"Bordes y Plataformas/Techo con gancho/Caja".mode = RigidBody2D.MODE_STATIC
	elif (distanceCajaPj < 55):
		if($PersonajeJugable.caminando):
			$"Bordes y Plataformas/Techo con gancho/Caja".mode = RigidBody2D.MODE_RIGID
		else:
			$"Bordes y Plataformas/Techo con gancho/Caja".mode = RigidBody2D.MODE_STATIC

func _on_Coin_pj_entered():
	coins_collected += 1
	$Coin.play()
	$CanvasLayer/Coins.text = str(coins_collected)


func _on_Timer_timeout():
	if (seconds >= 1):
		seconds -= 1
		$CanvasLayer/Timer.text = str(seconds)
	else:
		ChangeScene.lastLevel = "res://Niveles/SegundoNivel.tscn"
		get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_Button_pressed():
	get_tree().reload_current_scene()
	
func check_ending():
	if(puede_avanzar):
		if(esta_en_final && Input.is_action_just_pressed('ui_accept')):
			get_tree().change_scene("res://Niveles/TercerNivel.tscn")


func _on_Caja_Final_personaje_entro():
	if(puede_avanzar):
		get_tree().change_scene("res://Niveles/TercerNivel.tscn")


func _on_Caja_Final_personaje_salio():
	esta_en_final = false


func _on_Area2D_body_entered(body):
	if (body.name == "PersonajeJugable"):
		ChangeScene.lastLevel = "res://Niveles/SegundoNivel.tscn"
		get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_MusicaFondo_finished():
	$MusicaFondo.play()


func _on_enemigo_murio(body):
	enemigos.erase(body.name)
	
func set_position_to_enemies():
	for enemigo in enemigos.values():
		enemigo.personajeJugablePosition = $PersonajeJugable.global_position


func _on_EnemigoRojo_kill_pj():
	ChangeScene.lastLevel = "res://Niveles/SegundoNivel.tscn"
	get_tree().change_scene("res://Resources/GameOver.tscn")
