extends Node2D

var max_coins = 10
var coins = 0
var seconds = 20
var puede_avanzar = false
var esta_en_final = false
signal juego_frenado()
signal juego_activo()

var enemigos = {}

func _ready():
	$"Trampa/Caja Activa/AnimatedSprite".play("fin")
	$PersonajeJugable/Camera2D.limit_right = 1436
	$MusicaFondo.play()
	$"Top Line/Time".text = str(seconds)
	
	enemigos = {
			"EnemigoRojo1" : $"Plataformas flotantes/Plataformita/EnemigoRojo1",
			"EnemigoRojo2" : $"Plataformas flotantes/Plataformita3/EnemigoRojo2",
			"EnemigoRojo3" : $Piso/EnemigoRojo3,
			"EnemigoRojo4" : $"Plataformas flotantes/Plataformita2/EnemigoRojo4",
			"EnemigoRojo5" : $Piso/EnemigoRojo5,
			"EnemigoRojo6" : $"Plataformas flotantes/Plataformita4/EnemigoRojo6"
		}
	
	$"Plataformas flotantes/Plataformita/EnemigoRojo1".left_top_distance = -40
	$"Plataformas flotantes/Plataformita/EnemigoRojo1".right_top_distance = 43
	$"Plataformas flotantes/Plataformita2/EnemigoRojo4".right_top_distance = 42
	$"Plataformas flotantes/Plataformita2/EnemigoRojo4".left_top_distance = -44
	$"Plataformas flotantes/Plataformita3/EnemigoRojo2".right_top_distance = 40
	$"Plataformas flotantes/Plataformita3/EnemigoRojo2".left_top_distance = -40
	$"Plataformas flotantes/Plataformita4/EnemigoRojo6".right_top_distance = 50
	$"Plataformas flotantes/Plataformita4/EnemigoRojo6".left_top_distance = -40
	$Piso/EnemigoRojo3.left_top_distance = 405
	$Piso/EnemigoRojo3.right_top_distance = 555
	$Piso/EnemigoRojo5.left_top_distance = 612
	$Piso/EnemigoRojo5.right_top_distance = 834
	
func _frenar_juego():
	emit_signal("juego_frenado")
	$"Top Line/Time/clock4".visible = true
	$"Top Line/Time/clock".visible = false
	$"Top Line/Time".modulate = Color(1, 0, 0) 
	$Timer.stop()

func _retomar_juego():
	emit_signal("juego_activo")
	$"Top Line/Time/clock4".visible = false
	$"Top Line/Time/clock".visible = true
	$"Top Line/Time".modulate = Color(1, 1, 1) 	
	if $Timer.is_stopped():
		$Timer.start()
	
func _process(delta):
	set_position_to_enemies()
	if (coins == 10):
		puede_avanzar = true
		$CajaFinal/AnimatedSprite.play("fin")
	else:
		$CajaFinal/AnimatedSprite.play("mitad")
	check_ending()
	if $PersonajeJugable.caminando:
		_retomar_juego()
	else:
		_frenar_juego()

func _on_Coin_pj_entered():
	coins += 1
	$Coin.play()
	$"Top Line/Coins".text = str(coins)


func _on_Area2D_body_entered(body):
	if (body.name == "PersonajeJugable"):
		$PersonajeJugable.jump_power_up()
		$Area2D.queue_free()

func _on_Timer_timeout():
	if (seconds >= 1):
		seconds -= 1
		$"Top Line/Time".text = str(seconds)
	else:
		ChangeScene.lastLevel = "res://Niveles/TercerNivel.tscn"
		get_tree().change_scene("res://Resources/GameOver.tscn")

func _on_Area2D2_body_entered(body):
	if (body.name == "PersonajeJugable"):
		ChangeScene.lastLevel = "res://Niveles/TercerNivel.tscn"
		get_tree().change_scene("res://Resources/GameOver.tscn")

func _on_CajaFinal_personaje_entro():
	if puede_avanzar:
		get_tree().change_scene("res://Resources/JuegoFinalizado.tscn")

func _on_CajaFinal_personaje_salio():
	esta_en_final = false

func check_ending():
	if(puede_avanzar):
		if(esta_en_final && Input.is_action_just_pressed('ui_accept')):
			get_tree().change_scene("res://Resources/JuegoFinalizado.tscn")

func _on_Caja_Activa_personaje_entro():
	get_tree().change_scene("res://Resources/JuegoFinalizado.tscn")

func _on_Caja_Activa_personaje_salio():
	esta_en_final = false

func _on_MusicaFondo_finished():
	$MusicaFondo.play()


func _on_enemigo_murio(body):
	enemigos.erase(body.name)
	
func set_position_to_enemies():
	for enemigo in enemigos.values():
		if enemigo != null:
			enemigo.personajeJugablePosition = $PersonajeJugable.global_position


func _on_EnemigoRojo_kill_pj():
	ChangeScene.lastLevel = "res://Niveles/TercerNivel.tscn"
	get_tree().change_scene("res://Resources/GameOver.tscn")
