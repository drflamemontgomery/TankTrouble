extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var speed = 80
var velocity = Vector2()
var true_parent
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func spawn(pos, dir, player):
	true_parent = player
	rotation = dir
	position = pos
	velocity = Vector2(0, -speed).rotated(rotation)
	rotation = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	rotation = 0
	var collision = move_and_collide(velocity * delta)
	if collision:
		velocity =velocity.bounce(collision.normal)
		
		if collision.collider.has_method("hit"):
			collision.collider.hit()
			hit()
	
	
#	if $Down.is_colliding() or $Up.is_colliding():
#		velocity.y = -velocity.y
#	if $Left.is_colliding() or $Right.is_colliding():
#		velocity.x = -velocity.x
#	position -= Vector2(velocity.x / velocity.x, velocity.y / velocity.y).rotated(rotation)

func hit():
	if get_parent().get_node(true_parent):
		get_parent().get_node(true_parent).ball_count -= 1
	queue_free()



func _on_Timer_timeout():
	hit()


func _on_Area2D_body_entered(body):
	if body.has_method("hit"):
		body.hit()
		hit()
