extends Node2D

signal personaje_entro()
signal personaje_salio()

func _on_Area2D_body_shape_entered(body_id, body, body_shape, area_shape):
	if(body.name == "PersonajeJugable"):
		emit_signal("personaje_entro")

func _on_Area2D_body_shape_exited(body_id, body, body_shape, area_shape):
	if(body.name == "PersonajeJugable"):
		emit_signal("personaje_salio")

func _on_Level_juego_frenado():
	$AnimatedSprite.stop()

func _on_Level_juego_activo():
	$AnimatedSprite.play()


