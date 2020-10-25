extends Node2D

var coins_total = 14
var coins_collected = 0
var seconds = 60
var puede_avanzar = false
var esta_en_final = false

func _process(delta):
	check_distance_caja()
	check_ending()
	if (coins_collected == 14):
		$"Caja Final/AnimatedSprite".play("fin")
		puede_avanzar = true
	elif (coins_collected >= 7):
		$"Caja Final/AnimatedSprite".play("mitad")

func check_distance_caja():
	var distanceCajaPj = $PersonajeJugable.position.distance_to($"Bordes y Plataformas/Techo con gancho/Caja".position)
	var distanceCajaPlataforma = $"Bordes y Plataformas/Techo con gancho/Caja".position.distance_to($"Bordes y Plataformas/Plataforma Alta/StaticBody2D".position)
	
	if (distanceCajaPlataforma > 405):
		$"Bordes y Plataformas/Techo con gancho/Caja".mode = RigidBody2D.MODE_STATIC
	elif (distanceCajaPj < 55):
		$"Bordes y Plataformas/Techo con gancho/Caja".mode = RigidBody2D.MODE_RIGID
	

func _on_Coin_pj_entered():
	coins_collected += 1
	$CanvasLayer/Coins.text = str(coins_collected)


func _on_Timer_timeout():
	if (seconds >= 1):
		seconds -= 1
		$CanvasLayer/Timer.text = str(seconds)


func _on_Button_pressed():
	get_tree().reload_current_scene()
	
func check_ending():
	if(puede_avanzar):
		if(esta_en_final && Input.is_action_just_pressed('ui_accept')):
			get_tree().change_scene("res://SegundoNivel/SegundoNIvel.tscn")


func _on_Caja_Final_personaje_entro():
	esta_en_final = true


func _on_Caja_Final_personaje_salio():
	esta_en_final = false


func _on_Caja_body_shape_entered(body_id, body, body_shape, area_shape):
	print(body.name)
