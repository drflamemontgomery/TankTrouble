extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Ball = load("res://Scenes/Bullet.tscn")
var speed = 75
var rotating = ""
var velocity = Vector2()
var ball_max = 6
var ball_count = 0
var choose = false
var prev_pos = position
var prev_rotation = rotation_degrees
var astar = AStar.new()
var id_dict = {}
var maze
var size
var my_cell = 0
var their_cell = 0
var moveable = false
var cell_move
# Called when the node enters the scene tree for the first time.
func _ready():
	$Finder.add_exception(RayCast2D)
	$RayCast2D.add_exception(RayCast2D)
	$AnimatedSprite.animation = "default"
	moveable = false
	

func connect_astar():
	
	# create astar graph points
	var i = 0
	for x in size.x:
		for y in size.y:
			astar.add_point(i, Vector3(x, y, 0))
			#print_debug("Creating point " + str(i)+ ":" + str(x) + "," + str(y))
			i += 1
	
	# connect astar graph points
	i = 0
	for x in size.x:
		for y in size.y:
			if maze.rooms[Vector2(x, y)].is_open(2):
				# check if col is edge
				if (i%int(size.x)) < size.x: 
					astar.connect_points(i, i+1)
			if maze.rooms[Vector2(x, y)].is_open(8):
				# check if row is edge
				if (i/int(size.x)) < size.y:
					astar.connect_points(i, i+size.x)
			i += 1
	
	# build dictionary from astar graph
	var points = astar.get_points()
	for id in points:
		id_dict[id] = Vector2(astar.get_point_position(id).x, astar.get_point_position(id).y)
	#print_debug(size)
	#print_debug(Vector2(my_cell, their_cell))
	#print_debug(astar.get_id_path(my_cell, their_cell))
	#print_debug(id_dict[30])
	
	#for i in id_dict:
	#	print_debug(str(id_dict[i]) + "," + str(i))
	print_debug(astar.get_point_path(my_cell, their_cell))
	for i in astar.get_id_path(my_cell, their_cell):
		#print_debug(astar.get_point_position(i))
		#print_debug(id_dict[i])
		pass
	moveable = true
		#print_debug(Vector2(i%int(size.x)-1, i/int(size.x)))

func get_cell_move():
	var tmp_dict = []
	for i in astar.get_id_path(my_cell, their_cell):
		tmp_dict.push_front(i)
		#print_debug(i)
	# remove my cell to find what cell to move to
	tmp_dict.pop_back()
	if tmp_dict.size() > 0:
		var return_val = tmp_dict.pop_back()
		
		#print_debug(str(id_dict[int(my_cell)]) + "->" +str(id_dict[int(return_val)]))
		return return_val
	return null

func left():
	rotating = "left"

func right():
	rotating = "right"

func up():
	velocity = Vector2(0, -speed).rotated(rotation)

func down():
	velocity = Vector2(0, speed*2).rotated(rotation)

func spawn_ball():
	ball_count += 1
	var b = Ball.instance()
	if $RayCast2D.is_colliding():
		b.spawn(position + Vector2(0, -9.6).rotated(rotation), rotation, "Laika")
	else:
		b.spawn(position + Vector2(0, -13).rotated(rotation), rotation, "Laika")
	get_parent().add_child(b)


func choose_move():
	if $Finder.is_colliding():
		if $Finder.get_collider().get_filename() == "res://Scenes/Player.tscn":
			spawn_ball()
			return
	#print_debug(str(id_dict[int(my_cell)]) + "->" + str(id_dict[int(their_cell)]))
	var dir = get_direction(cell_move)
	#print(dir)
	
	if dir == "up":
		if rotation_degrees > -20 or rotation_degrees < 20:
			rotating = null
			rotation_degrees = 0
			up()
		else:
			right()
			print_debug("up")
	if dir == "down":
		if rotation_degrees > 160 or rotation_degrees < 200:
			right()
			print_debug("down")
		else:
			up()
			rotating = null
			rotation_degrees = 180
	if dir == "left":
		if rotation_degrees > 250 or rotation_degrees < 290:
			up()
			rotating = null
			rotation_degrees = 90
		else:
			right()
			print_debug("left")
	if dir == "right":
		if rotation_degrees > 250 or rotation_degrees < 290:
			up()
			rotating = null
			rotation_degrees = 270
		else:
			right()
			print_debug("right")
	#choose = false
	#rotating = null
	#up()

func get_direction(cell):
	print_debug(id_dict[cell])
	print_debug(id_dict[int(my_cell)])
	#print_debug(str(id_dict[int(my_cell)]) + "->" + str(id_dict[int(cell)]))
	if my_cell && cell:
		if id_dict[int(my_cell)] - Vector2(0, 1) == id_dict[int(cell)]:
			print_debug("left")
			return "left"
		if id_dict[int(my_cell)] + Vector2(0, 1) == id_dict[int(cell)]:
			print_debug("right")
			return "right"
		if id_dict[int(my_cell)] + Vector2(1, 0) == id_dict[int(cell)]:
			print_debug("up")
			return "up"
		if id_dict[int(my_cell)] - Vector2(1, 0) == id_dict[int(cell)]:
			print_debug("down")
			return "down"
		#print_debug(" ")
		return null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if $AnimatedSprite.animation != "Dead":
		if get_parent().get_parent().get_filename() == "res://Scenes/Gamestate.gd":
			get_parent().get_parent().laika_cell = Vector2(int(position.x/2), int(position.y/32))
		#rotation = rotation_dir * rotation_speed# * delta
		if moveable:
			cell_move = get_cell_move()
			choose_move()
			velocity = move_and_slide(velocity)
		return
	rotation = 0
	$Timer.stop()
	if $AnimatedSprite.animation == "Dead" and $AnimatedSprite.get_frame() == 4:
		queue_free()
	pass

func _on_Timer_timeout():
	if rotating == "left":
		rotation_degrees -= 5
		#rotation -= 0.1
	if rotating == "right":
		rotation_degrees += 5
