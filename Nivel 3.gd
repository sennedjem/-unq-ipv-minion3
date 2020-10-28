extends Node2D

var max_coins = 10
var coins = 0
var seconds = 20
var puede_avanzar = false
var esta_en_final = false

func _ready():
	$"Trampa/Caja Activa/AnimatedSprite".play("fin")
	$PersonajeJugable/Camera2D.limit_right = 1436
	$MusicaFondo.play()
	
func _process(delta):
	if (coins == 10):
		puede_avanzar = true
		$CajaFinal/AnimatedSprite.play("fin")
	elif (coins == 5):
		$CajaFinal/AnimatedSprite.play("mitad")
	check_ending()

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
		get_tree().change_scene("res://GameOver/GameOver.tscn")


func _on_Area2D2_body_entered(body):
	if (body.name == "PersonajeJugable"):
		get_tree().change_scene("res://GameOver/GameOver.tscn")


func _on_CajaFinal_personaje_entro():
	esta_en_final = true
	if !$Success.playing:
		$Success.play()
		$MusicaFondo.stop()


func _on_CajaFinal_personaje_salio():
	esta_en_final = false

func check_ending():
	if(puede_avanzar):
		if(esta_en_final && Input.is_action_just_pressed('ui_accept')):
			get_tree().change_scene("res://JuegoFinalizado/JuegoFinalizado.tscn")


func _on_Caja_Activa_personaje_entro():
	esta_en_final = true
	puede_avanzar = true


func _on_Caja_Activa_personaje_salio():
	esta_en_final = false
