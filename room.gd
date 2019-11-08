extends Node

var openings = 0
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
func connected():
	return self.openings > 0
# Called when the node enters the scene tree for the first time.
func open(direction):
	self.openings |= direction

func is_open(direction):
	return self.openings & direction > 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
