extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maze = load("res://Scenes/Level_gen.gd")
#var maze = load("res://Testing.gd")
var rc = load("res://recursion.gd")
var p_Queue = load("res://Priority Queue.gd")
var prior_queue = p_Queue.new()
var left = maze.left
var right = maze.right
var up = maze.up
var down = maze.down
var rand_vec
var p1_cell
var laika_cell
var object = load("res://object.gd")
var laika_cur_cell
var changeable = false
# Called when the node enters the scene tree for the first time.

func _ready():
	#$Selection.show()
	#$Level.hide()
	#run()
	#$Level/Camera2D.current = false
	run()
	pass

func run():
	randomize()
	rand_vec = Vector2(randi()%9+8, randi()%9+8)
	var maze = self.maze.new(rand_vec.x, rand_vec.y)
	#var maze = self.maze.new()
	var rc = self.rc.new(maze, 0, 0)
	#print_debug(randi())
	var p1_spawn = Vector2(randi()%int(maze.size.x)*32+16, randi()%int(maze.size.y)*32+32)
	var laika_spawn = p1_spawn
	
	while laika_spawn == p1_spawn:
		laika_spawn = Vector2(randi()%int(maze.size.x)*32+16, randi()%int(maze.size.y)*32+32)
	rc.generate()
	#output()
	print_debug(String(maze.size.x) + String(maze.size.y))
	maze.output()
	render_maze(maze)
	$Level/Player.position = p1_spawn
	$Level/Laika.position = laika_spawn
	laika_cell = Vector2(int(laika_spawn.x/32)+1, int(laika_spawn.y/32))
	p1_cell = Vector2(int(p1_spawn.x/32), int(p1_spawn.y/32))
	randomize()
	$Level/Camera2D.position = Vector2((maze.size.x*32)/2+64, ((maze.size.y*32)/2)+32)
#	if maze.size.y > maze.size.x:
	$Level/Camera2D.zoom = Vector2(maze.size.y / 15, maze.size.y / 15)
	print_debug($Level/Camera2D.position)
	$Level/Laika.maze = maze
	$Level/Laika.size = maze.size
	$Level/Laika.my_cell = laika_cell.x * laika_cell.y
	$Level/Laika.their_cell = p1_cell.x * p1_cell.y
	$Level/Laika.connect_astar()
	changeable = true
#	else:
#		$Camera2D.scale = Vector2(maze.size.x / 16, maze.size.x / 16)

func _process(delta):
	laika_cur_cell = Vector2(int($Level/Laika.position.x/32), int($Level/Laika.position.y/32))
	if changeable:
		if laika_cell != laika_cur_cell:
			print_debug("change_cell")
	laika_cell.x = int(laika_cur_cell.x)
	laika_cell.y = int(laika_cur_cell.y)
	$Level/Laika.my_cell = laika_cell.x * laika_cell.y
	#$Level/Laika.connect_astar()
	#laika_cur_cell = laika_cell
	#print_debug(laika_cell)
	if $Level.visible:
		if !$Level/Player:
			if $Level/Timer:
				if $Level/Timer.is_stopped():
					$Level/Timer.start()
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()

func render_maze(maze):
	var vertical = $Level.get_node("TileMap2")
	var horizontal = $Level.get_node("TileMap")
	var vtileset = vertical.get_tileset()
	var htileset = horizontal.get_tileset()
	var VTile = "Vertical"
	var HTile = "Horizontal"
	var vtile = vtileset.find_tile_by_name(VTile)
	var htile = htileset.find_tile_by_name(HTile)
	for i in maze.size.x:
		horizontal.set_cell(i, 0, htile)
		horizontal.set_cell(i, rand_vec.y, htile)
	for i in maze.size.y:
		vertical.set_cell(0, i, vtile)
		vertical.set_cell(rand_vec.x, i, vtile)
	
	
	for y in range(maze.size.y + 1):
		for x in range(maze.size.x + 1):
			#var maze_left = maze.room(Vector2(x - 1, y - 1))
			#var maze_right = maze.room(Vector2(x, y - 1))
			#var bottom_left = maze.room(Vector2(x - 1, y))
			#var bottom_right = maze.room(Vector2(x, y))
			
			if wall(maze.room(Vector2(x, y)), down):
				horizontal.set_cell(x, y+1, htile)
			if wall(maze.room(Vector2(x, y)), right):
				vertical.set_cell(x+1, y, vtile)
			if wall(maze.room(Vector2(x, y)), up):
				horizontal.set_cell(x, y, htile)
			if wall(maze.room(Vector2(x, y)), left):
				vertical.set_cell(x, y, vtile)

func wall(room, direction):
	if room == null:
		return false
	
	return !room.is_open(direction)

func output():
	var result = ""
	
	for top in range((maze.output_size.x * 2) + 1):
		result += "_"
	
	for y in range(maze.output_size.y):
			result += "\n|"
			
			for x in range(maze.output_size.x):
				var room = maze.room(Vector2(x, y))
				result += " " if room.is_open(down) else "_"
				result += " " if room.is_open(right) else "|"
	
	print(result)

func _on_Timer_timeout():
	$Level/Timer2.start()
	print_debug($Level/Timer2.is_stopped())
	if $Level/Player:
		$Level/CanvasLayer/Label.show()
		$Level/CanvasLayer/Label.text = "Player1 Wins"
		print_debug("Player1 Wins")
		$Level/Timer.queue_free()
		return
	$Level/CanvasLayer/Label.show()
	$Level/CanvasLayer/Label.text = "No One Wins"
	$Level/Timer.queue_free()


func _on_Timer2_timeout():
	print_debug("reload")
	get_tree().reload_current_scene()
