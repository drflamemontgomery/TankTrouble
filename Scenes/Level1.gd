extends Area2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var prev_screensize
# Called when the node enters the scene tree for the first time.
func _ready():
	$Camera2D.position = $Middle.position
	$TileMap.queue_free()
	$TileMap2.queue_free()
	$TileMap4.queue_free()
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("reset"):
		get_tree().reload_current_scene()
	var get_scale = OS.get_real_window_size().x / 1028
	if prev_screensize == get_scale:
	#	print_debug(OS.get_real_window_size().x)
	#	print_debug(get_scale)
		return
	$Camera2D.zoom = Vector2(1-((get_scale-1)*0.5), 1-((get_scale-1)*0.5))
	prev_screensize = get_scale
