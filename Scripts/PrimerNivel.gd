extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
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
	print($PersonajeJugable.caminando)
	if $PersonajeJugable.caminando:
		_retomar_juego()
	else:
		_frenar_juego()
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Coin_pj_entered():
	monedas = monedas + 1
	$Coin.play()
	$CanvasLayer/Monedas.text = str(monedas)

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
	$Timer.stop()
	$CajaFinal/AnimatedSprite.stop()

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
	if $Timer.is_stopped():
		$Timer.start()
	$CajaFinal/AnimatedSprite.play()

func _on_PersonajeJugable_pj_step():
	#if pasos_restantes > 0:
	#	pasos_restantes = pasos_restantes-1
	#	$CanvasLayer/Pasos/Cantidad.text = str(pasos_restantes)
	#else:
	#	game_over()	
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
