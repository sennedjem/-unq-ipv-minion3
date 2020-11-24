extends Node


# Declare member variables here. Examples:
# var a = 2
var lastLevel = null
var pause = false

# Called when the node enters the scene tree for the first time.
func _game_over(lastLevel):
	self.lastLevel = lastLevel
	print(self.lastLevel)
	get_tree().change_scene("res://Resources/GameOver.tscn")
	
func _reiniciar_nivel():
	print(self.lastLevel)
	var root = get_tree().get_root()
	print(root.get_child(root.get_child_count() -1))
	get_tree().change_scene(self.lastLevel)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
