extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const left = 1
const right = 2
const up = 4
const down = 8
const Directions = [left, right, up, down]
var size = Vector2()
var rooms = {}
var Room = load("res://room.gd")
const Dx = {left : -1, right : 1, up : 0, down : 0}
const Dy = {left : 0, right : 0, up : -1, down : 1}
const opposites = {left : right, right : left, up : down, down:up}
# Called when the node enters the scene tree for the first time.


func _init(width, height):
	initialize(width, height)

func initialize(Vx, Vy):
	randomize()
	size = Vector2(Vx, Vy)
	for x in size.x:
		for y in size.y:
			rooms[Vector2(x, y)] = Room.new()

func delta(location, direction):
	return Vector2(location.x + Dx[direction], location.y + Dy[direction])

func connections(location, direction):
	var room = self.room(location)
	var connected_room = self.neighbour(location, direction)
	room.open(direction)
	connected_room.open(opposites[direction])

func neighbour(location, direction):
	var delta = self.delta(location, direction)
	return self.room(delta)

func room(location):
	if not self.valid(location):
		return null
	
	return self.rooms[location]

func valid(location):
	if location.x < 0 or location.x >= size.x:
		return false
	if location.y < 0 or location.y >= size.y:
		return false

func directions(location):
	var directions = []
	
	for direction in Directions:
		var neighbour = self.neighbour(location, direction)
		
		if neighbour != null:
			directions.append(direction)
	
	return directions
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
