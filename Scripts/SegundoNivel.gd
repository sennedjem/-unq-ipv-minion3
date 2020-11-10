extends Node2D

var coins_total = 14
var coins_collected = 0
var seconds = 60
var puede_avanzar = false
var esta_en_final = false

func _ready():
	$MusicaFondo.play()

func _process(delta):
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
	if $Monedas/Coin/AnimatedSprite:
		$Monedas/Coin/AnimatedSprite.stop()
	if $Monedas/Coin2/AnimatedSprite:
		$Monedas/Coin2/AnimatedSprite.stop()
	if $Monedas/Coin3/AnimatedSprite:
		$Monedas/Coin3/AnimatedSprite.stop()
	if $Monedas/Coin4/AnimatedSprite:
		$Monedas/Coin4/AnimatedSprite.stop()
	if $Monedas/Coin5/AnimatedSprite:
		$Monedas/Coin5/AnimatedSprite.stop()
	if $Monedas/Coin6/AnimatedSprite:
		$Monedas/Coin6/AnimatedSprite.stop()
	if $Monedas/Coin7/AnimatedSprite:
		$Monedas/Coin7/AnimatedSprite.stop()
	if $Monedas/Coin8/AnimatedSprite:
		$Monedas/Coin8/AnimatedSprite.stop()
	if $Monedas/Coin9/AnimatedSprite:
		$Monedas/Coin9/AnimatedSprite.stop()
	if $Monedas/Coin10/AnimatedSprite:
		$Monedas/Coin10/AnimatedSprite.stop()
	if $Monedas/Coin11/AnimatedSprite:
		$Monedas/Coin11/AnimatedSprite.stop()
	if $Monedas/Coin12/AnimatedSprite:
		$Monedas/Coin12/AnimatedSprite.stop()
	if $Monedas/Coin13/AnimatedSprite:
		$Monedas/Coin13/AnimatedSprite.stop()
	if $Monedas/Coin14/AnimatedSprite:
		$Monedas/Coin14/AnimatedSprite.stop()					
	$Timer.stop()
	$"Caja Final/AnimatedSprite".stop()

func _retomar_juego():
	if $Monedas/Coin/AnimatedSprite:
		$Monedas/Coin/AnimatedSprite.play()
	if $Monedas/Coin2/AnimatedSprite:
		$Monedas/Coin2/AnimatedSprite.play()
	if $Monedas/Coin3/AnimatedSprite:
		$Monedas/Coin3/AnimatedSprite.play()
	if $Monedas/Coin4/AnimatedSprite:
		$Monedas/Coin4/AnimatedSprite.play()
	if $Monedas/Coin5/AnimatedSprite:
		$Monedas/Coin5/AnimatedSprite.play()
	if $Monedas/Coin6/AnimatedSprite:
		$Monedas/Coin6/AnimatedSprite.play()
	if $Monedas/Coin7/AnimatedSprite:
		$Monedas/Coin7/AnimatedSprite.play()
	if $Monedas/Coin8/AnimatedSprite:
		$Monedas/Coin8/AnimatedSprite.play()
	if $Monedas/Coin9/AnimatedSprite:
		$Monedas/Coin9/AnimatedSprite.play()
	if $Monedas/Coin10/AnimatedSprite:
		$Monedas/Coin10/AnimatedSprite.play()	
	if $Monedas/Coin11/AnimatedSprite:
		$Monedas/Coin11/AnimatedSprite.stop()
	if $Monedas/Coin12/AnimatedSprite:
		$Monedas/Coin12/AnimatedSprite.stop()
	if $Monedas/Coin13/AnimatedSprite:
		$Monedas/Coin13/AnimatedSprite.stop()
	if $Monedas/Coin14/AnimatedSprite:
		$Monedas/Coin14/AnimatedSprite.stop()		
	if $Timer.is_stopped():
		$Timer.start()
	$"Caja Final/AnimatedSprite".play()			

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
	#esta_en_final = true
	#if !$Success.playing:
	#	$Success.play()
	#	$MusicaFondo.stop()


func _on_Caja_Final_personaje_salio():
	esta_en_final = false


func _on_Area2D_body_entered(body):
	if (body.name == "PersonajeJugable"):
		get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_MusicaFondo_finished():
	$MusicaFondo.play()
