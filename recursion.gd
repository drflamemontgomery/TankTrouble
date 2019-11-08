var maze
var x
var y
var stack = []

func _init(maze, x, y):
	self.maze = maze
	self.x = x
	self.y = y
	
func generate():
	randomize()
	self.stack.push_back(Vector2(self.x, self.y))
	
	while self.stack.size() > 0:
		var location = self.stack.back()
		var direction = choose_random_direction(location)
		
		if direction == null:
			self.stack.pop_back()
			continue
			
		self.maze.connections(location, direction)
		location = self.maze.delta(location, direction)
		self.stack.push_back(location)
	for i in range(self.maze.size.x * self.maze.size.y*2.5):
		var location = Vector2(randi() % int(self.maze.size.x), randi() % int(self.maze.size.y))
		#print_debug(self.maze.rooms)
		if self.maze.rooms[location].connected():
			var direction = self.maze.Directions[randi()%4]
			if !self.maze.rooms[location].is_open(direction):
				self.maze.rooms[location].open(direction)

func choose_random_direction(location):
	var directions = []
	
	for direction in maze.directions(location):
		var neighbor = self.maze.neighbour(location, direction)
		if not neighbor.connected():
			directions.append(direction)
	
	if directions.size() == 0:
		return null
		
	var random_index = randi() % directions.size()
	return directions[random_index]