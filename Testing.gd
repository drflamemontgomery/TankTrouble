extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const left = 1
const right = 2
const up = 4
const down = 8
const Directions = [left, right, up, down]
var Room = load("res://room.gd")
var room = {}
var size = Vector2(4,4)
# Called when the node enters the scene tree for the first time.
func _init():
	for x in size.x:
		for y in size.y:
			room[Vector2(x,y)] = Room.new()

func room(location):
	if not self.valid(location):
		return null
	
	return self.room[location]

func valid(location):
	if location.x < 0 or location.x >= size.x:
		return false
	if location.y < 0 or location.y >= size.y:
		return false
	
	return true