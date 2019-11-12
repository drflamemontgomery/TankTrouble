extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var pos = Vector2()
var distance
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _init(vector, distance):
	pos = vector
	self.distance = distance

func set_distance(distance):
	self.distance = distance

func get_distance():
	return distance

func get_pos():
	return pos
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
