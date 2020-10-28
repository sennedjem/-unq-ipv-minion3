extends Node2D

func _ready():
	$GameOverAudio.play()
	pass

func _on_IniciarJuegoBoton_pressed():
	 get_tree().change_scene("res://Resources/EscenaInicial.tscn")
