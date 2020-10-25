extends Node2D

signal pj_entered()

func _on_Area2D_body_entered(body):
	if (body.name == "PersonajeJugable"):
		emit_signal("pj_entered")
		queue_free()
