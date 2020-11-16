extends Node2D

const IDLE_DURATION = 1.0

export var move_to = Vector2.RIGHT * 192
export var speed = 2.0

onready var platform = $Platform
onready var tween = $MoveTween

var activo = false

var follow = Vector2.ZERO

func _ready():
	_init_tween()
	
func _init_tween():
	var duration = move_to.length() / float(speed * 84)
	tween.interpolate_property(self, "follow", Vector2.ZERO, move_to, duration, Tween.TRANS_LINEAR, Tween.EASE_OUT, IDLE_DURATION)
	tween.interpolate_property(self, "follow", move_to, Vector2.ZERO, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, duration + IDLE_DURATION * 2)
	tween.start()
	
func _physics_process(delta):
	if (activo):
		platform.position = platform.position.linear_interpolate(follow, 0.075)


func _on_Level_juego_activo():
	tween.start()
	activo = true


func _on_Level_juego_frenado():
	tween.stop(tween, "follow")
	activo = false
