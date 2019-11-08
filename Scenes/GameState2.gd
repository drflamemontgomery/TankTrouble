extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var maze = load("res://Scenes/Level_gen.gd")
var rc = load("res://recursion.gd")
var left = maze.left
var right = maze.right
var up = maze.up
var down = maze.down
var rand_vec
var cmaze
# Called when the node enters the scene tree for the first time.

func _ready():
	#$Selection.show()
	#$Level.hide()
	#run()
	#$Level/Camera2D.current = false
	run()
	pass

func run():
	$Level/Camera2D.current = true
	$Level.show()
	$Level/Player3.queue_free()
	randomize()
	rand_vec = Vector2(randi()%9+8, randi()%9+8)
	var maze = self.maze.new(rand_vec.x, rand_vec.y)
	cmaze = maze
	var rc = self.rc.new(maze, 0, 0)
	#print_debug(randi())
	var p1_spawn = Vector2(randi()%int(maze.size.x)*32+16, randi()%int(maze.size.y)*32+32)
	rc.generate()
	var p2_spawn = Vector2(randi()%int(maze.size.x)*32+16, randi()%int(maze.size.y)*32+32)
	#debug_render(maze)
	render_maze(maze)
	maze.output()
	$Level/Player.position = p1_spawn
	$Level/Player2.position = p2_spawn
	$Level/Camera2D.position = Vector2((maze.size.x*32)/2+1, ((maze.size.y*32)/2)+64)
#	if maze.size.y > maze.size.x:
	$Level/Camera2D.zoom = Vector2(maze.size.y / 15, maze.size.y / 15)
	print_debug($Level/Camera2D.position)
#	else:
#		$Camera2D.scale = Vector2(maze.size.x / 16, maze.size.x / 16)

func _process(delta):
	if $Level.visible:
		if !$Level/Player or !$Level/Player2:
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
	for i in rand_vec.x:
		horizontal.set_cell(i, 0, htile)
		horizontal.set_cell(i, rand_vec.y, htile)
	for i in rand_vec.y:
		vertical.set_cell(0, i, vtile)
		vertical.set_cell(rand_vec.x, i, vtile)
	
	
	for y in range(maze.size.y + 1):
		for x in range(maze.size.x + 1):
			var maze_left = maze.room(Vector2(x - 1, y - 1))
			var maze_right = maze.room(Vector2(x, y - 1))
			var bottom_left = maze.room(Vector2(x - 1, y))
			var bottom_right = maze.room(Vector2(x, y))
			
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
	if $Level/Player2:
		$Level/CanvasLayer/Label.show()
		$Level/CanvasLayer/Label.text = "Player2 Wins"
		$Level/Timer.queue_free()
		print_debug("Player2 Wins")
		return
	$Level/CanvasLayer/Label.show()
	$Level/CanvasLayer/Label.text = "No One Wins"
	$Level/Timer.queue_free()


func _on_Timer2_timeout():
	print_debug("reload")
	get_tree().reload_current_scene()
