extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prev_screensize = Vector2()
onready var viewport = $VBoxContainer/ViewportContainer/Viewport
onready var viewport2 = $VBoxContainer/ViewportContainer2/Viewport2
onready var viewport3 = $HBoxContainer/ViewportContainer3/Viewport3
onready var camera = $VBoxContainer/ViewportContainer/Viewport/Camera2D
onready var camera2 = $VBoxContainer/ViewportContainer2/Viewport2/Camera2D
onready var camera3 = $HBoxContainer/ViewportContainer3/Viewport3/Camera2D
onready var world = $VBoxContainer/ViewportContainer/Viewport/Level1
# Called when the node enters the scene tree for the first time.
func _ready():
	viewport2.world_2d = viewport.world_2d
	viewport3.world_2d = viewport.world_2d
	if world.get_node("Player"):
		camera.target = world.get_node("Player")
	if world.get_node("Player2"):
		camera2.target = world.get_node("Player2")
	if world.get_node("Player3"):
		camera3.target = world.get_node("Player3")
	print_debug(camera.target.get_filename())
	print_debug(camera2.target.get_filename())
	$HBoxContainer.rect_position.y = OS.get_real_window_size().y/2+2
	$HBoxContainer.rect_size = Vector2(OS.get_real_window_size().x, OS.get_real_window_size().y/2-1)
	$VBoxContainer.rect_size = Vector2(OS.get_real_window_size().x, OS.get_real_window_size().y/2-1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !world.get_node("Player2"):
		camera2.target = null
	if !world.get_node("Player"):
		camera.target = null
	if !world.get_node("Player3"):
		camera3.target = null
	var get_screen_size = OS.get_real_window_size()
	if prev_screensize == get_screen_size:
		#print_debug("change scale")
		return
	#print_debug($VBoxContainer.rect_size)
	#print_debug(get_scale_x)
	#print_debug(get_scale_y)
	prev_screensize = get_screen_size
	#$VBoxContainer.rect_size = Vector2(1024 * prev_screensize.x, 299 * prev_screensize.y)
	#$HBoxContainer.rect_size = Vector2(1024 * prev_screensize.x, 299 * prev_screensize.y)
	#$VBoxContainer.rect_size *= get_scale_x
	#$HBoxContainer.rect_size *= get_scale_x
	$HBoxContainer.rect_position.y = OS.get_real_window_size().y/2+2
	$HBoxContainer.rect_size = Vector2(OS.get_real_window_size().x, OS.get_real_window_size().y/2-1)
	$VBoxContainer.rect_size = Vector2(OS.get_real_window_size().x, OS.get_real_window_size().y/2-1)
	$VBoxContainer/ViewportContainer.rect_size = Vector2(OS.get_real_window_size().x/2-2, OS.get_real_window_size().y/2-1)
	$VBoxContainer/ViewportContainer2.rect_size = Vector2(OS.get_real_window_size().x/2-2, OS.get_real_window_size().y/2-1)
	$VBoxContainer/ViewportContainer2.rect_position = Vector2(OS.get_real_window_size().x/2+2, 0)
	$HBoxContainer/ViewportContainer3.rect_size = Vector2(OS.get_real_window_size().x/2-2, OS.get_real_window_size().y/2-1)
	print_debug($HBoxContainer.rect_size)
	print_debug($VBoxContainer.rect_size)
	print_debug(get_screen_size)