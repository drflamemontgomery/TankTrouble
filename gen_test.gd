extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maze
var x
var y
# Called when the node enters the scene tree for the first time.
func _init(maze, x, y):
	self.maze = maze
	self.x = x
	self.y = y

func generate():
	maze.room[Vector2(0, 0)].open(2)
	maze.room[Vector2(0, 0)].open(4)
	maze.room[Vector2(1, 0)].open(1)
	maze.room[Vector2(1, 0)].open(2)
	maze.room[Vector2(2, 0)].open(1)
	maze.room[Vector2(2, 0)].open(2)
	maze.room[Vector2(3, 0)].open(1)
	maze.room[Vector2(3, 0)].open(2)
	maze.room[Vector2(3, 0)].open(4)
	maze.room[Vector2(0, 1)].open(2)
	maze.room[Vector2(0, 1)].open(4)
	maze.room[Vector2(0, 1)].open(8)
	maze.room[Vector2(1, 1)].open(1)
	maze.room[Vector2(1, 1)].open(2)
	maze.room[Vector2(1, 1)].open(8)
	maze.room[Vector2(2, 1)].open(1)
	maze.room[Vector2(2, 1)].open(8)
	maze.room[Vector2(3, 1)].open(2)
	maze.room[Vector2(3, 1)].open(4)
	maze.room[Vector2(3, 1)].open(8)
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
