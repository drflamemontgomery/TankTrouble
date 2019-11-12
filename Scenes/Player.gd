extends KinematicBody2D

var Ball = preload("res://Scenes/Bullet.tscn")
export (String) var player_id = ''
export (int) var speed = 75
export (float) var rotation_speed = 0.07
var velocity = Vector2()
var rotation_dir = 0
var ball_count = 0
var ball_max = 6
var rotating = ""

func _ready():
	$AnimatedSprite.animation = "Player%s" % player_id

func get_input():
	velocity = Vector2()
	var left = Input.is_action_pressed("ui_left%s" % player_id)
	var right = Input.is_action_pressed("ui_right%s" % player_id)
	var up = Input.is_action_pressed("ui_up%s" % player_id)
	var down = Input.is_action_pressed("ui_down%s" % player_id)
	var shoot = Input.is_action_just_pressed("shoot%s" % player_id)
	
	if left:
		#rotation_dir -= 1
		rotating = "left"
	if right:
		#rotation_dir += 1
		rotating = "right"
	if up:
		velocity = Vector2(0, -speed).rotated(rotation)
		#velocity *= get_parent().scale
	if down:
		velocity = Vector2(0, speed/2).rotated(rotation)
		#velocity *= get_parent().scale
	if shoot && ball_count < ball_max:
		spawn_ball()
		ball_count += 1
	if !right and !left:
		rotating = null


func spawn_ball():
	var b = Ball.instance()
	if $RayCast2D.is_colliding():
		b.spawn(position + Vector2(0, -9.6).rotated(rotation), rotation, "Player%s" % player_id)
	else:
		b.spawn(position + Vector2(0, -13).rotated(rotation), rotation, "Player%s" % player_id)
	get_parent().add_child(b)
func _process(delta):
	if $AnimatedSprite.animation != "PlayerDead":
		if get_parent().get_filename() == "res://Scenes/Gamestate.tscn":
			get_parent().p1_cell = Vector2(int(position.x/32), int(position.y/32))
		get_input()
		#rotation = rotation_dir * rotation_speed# * delta
		velocity = move_and_slide(velocity)
		return
	rotation = 0
	$Timer.stop()
	if $AnimatedSprite.animation == "PlayerDead" and $AnimatedSprite.get_frame() == 4:
		queue_free()


func hit():
	$CollisionShape2D.disabled = true
	#rotation_dir = 0
	rotation = 0
	$AnimatedSprite.animation = "PlayerDead"

func _on_Timer_timeout():
	if rotating == "left":
		var rotating_deg = 5
		rotation_degrees -= 5
		#rotation -= 0.1
	if rotating == "right":
		var rotating_deg = 5
		rotation_degrees += 5
