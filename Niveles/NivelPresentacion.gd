extends Node2D


# Declare member variables here. Examples:
# var a = 2
signal juego_frenado()
signal juego_activo()
var caja_cayendo = false
var tiempo = 10
var enemigos = {}


# Called when the node enters the scene tree for the first time.
func _ready():
	enemigos = {
	"EnemigoRojo1": $Plataformas/plataforma2/EnemigoRojo1,
	"EnemigoRojo2": $Plataformas/plataforma4/EnemigoRojo2
	}
	$Plataformas/plataforma2/EnemigoRojo1.left_top_distance = -33
	$Plataformas/plataforma2/EnemigoRojo1.right_top_distance = 20
	$Plataformas/plataforma4/EnemigoRojo2.left_top_distance = -33
	$Plataformas/plataforma4/EnemigoRojo2.right_top_distance = 20
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	set_position_to_enemies()
	check_distance_caja()
	if($PersonajeJugable.caminando):
		$CanvasLayer/Time/RedClock.visible = false
		$CanvasLayer/Time/WhiteClock.visible = true
		$CanvasLayer/Time.modulate = Color(1, 1, 1) 
		emit_signal("juego_activo")
		if $Timer.is_stopped():
			$Timer.start()
	else:	
		$CanvasLayer/Time/RedClock.visible = true
		$CanvasLayer/Time/WhiteClock.visible = false
		$CanvasLayer/Time.modulate = Color(1, 0, 0) 
		emit_signal("juego_frenado")
		$Timer.stop()

func check_distance_caja():
	var distanceCajaPj = $PersonajeJugable.global_position.distance_to($"Limit horizontal/RigidBody2D".global_position)
	var distanceCajaPlataforma = $"Limit horizontal/RigidBody2D".global_position.distance_to($Plataformas/plataforma1/CollisionShape2D.global_position)
	if(distanceCajaPj < 55):
		caja_cayendo = true
	if($PersonajeJugable.caminando&&caja_cayendo):	
		$"Limit horizontal/RigidBody2D".mode = RigidBody2D.MODE_RIGID
	else:
		$"Limit horizontal/RigidBody2D".mode = RigidBody2D.MODE_STATIC

func _on_CajaFinal_personaje_entro():
	get_tree().change_scene("res://Niveles/PrimerNivel.tscn")


func _on_Area2D_body_entered(body):
	if (body.name == "PersonajeJugable"):
		ChangeScene.lastLevel = "res://Niveles/NivelPresentacion.tscn"
		get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_Coin_pj_entered():
	$CanvasLayer/Coins.text = "0"


func _on_Timer_timeout():
	tiempo = tiempo-1
	$CanvasLayer/Time.text = str(tiempo)


func _on_EnemigoRojo_kill_pj():
	ChangeScene.lastLevel = "res://Niveles/NivelPresentacion.tscn"
	get_tree().change_scene("res://Resources/GameOver.tscn")


func _on_EnemigoRojo1_enemigo_murio(body):
	enemigos.erase(body.name)

func set_position_to_enemies():
	for enemigo in enemigos.values():
		if (enemigo != null):
			enemigo.personajeJugablePosition = $PersonajeJugable.global_position
