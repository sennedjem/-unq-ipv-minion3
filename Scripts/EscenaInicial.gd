extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	$MusicaDeFondo.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass




func _on_IniciarJuegoBoton_pressed():
	 get_tree().change_scene("res://Niveles/NivelPresentacion.tscn")


func _on_AyudaBoton_pressed():
	 get_tree().change_scene("res://Resources/Ayuda.tscn")
