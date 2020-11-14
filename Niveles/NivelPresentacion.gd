extends Node2D


# Declare member variables here. Examples:
# var a = 2
signal juego_frenado()
signal juego_activo()
var caja_cayendo = false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	check_distance_caja()
	if($PersonajeJugable.caminando):
		emit_signal("juego_activo")
	else:	
		emit_signal("juego_frenado")

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
