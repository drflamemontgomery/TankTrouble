extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var s_vector
var their_cell
var maze
var priority_queue = load("res://Priority Queue.gd")
var pq
var distance = {}
var s_path_output_index = []
var s_path_edge_array = []
var size = Vector2()
# Called when the node enters the scene tree for the first time.
func _ready():
	pq = priority_queue.new()

func reload_variables(s_vector, their_cell, maze, size):
	self.s_vector = s_vector
	self.their_cell = their_cell
	self.maze = maze
	self.size = size

func find():
	for x in range(0, size.x):
		for y in range(0, size.y):
			#leastEdge[v] = null  unimplemented
			if Vector2(x, y) != s_vector:
				priority_queue.insert(i)
				distance[Vector2(x, y)] = -1
			else:
				distance[Vector2(x, y)] = 0
	s_path_output_index.append(s_vector)
	var tmp = s_vector
	while priority_queue.get_size() > 0:
		var tmp_d = distance[tmp]
		
		# check left
		if maze[tmp].is_open(1):
			var opp_v = maze[Vector2(tmp.x - 1, tmp.y)]
			if tmp_d + 1 < distance[opp_v]:
				distance[opp_v] = tmp_d + 1
		
		if maze[tmp].is_open(2):
			# check right
		if maze[tmp].is_open(4):
			# check up
		if maze[tmp].is_open(8):
			# check down


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
