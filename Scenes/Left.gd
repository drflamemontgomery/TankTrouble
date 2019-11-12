extends KinematicBody2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var velocity = get_parent().velocity

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var collision = move_and_collide(velocity * delta)
	if collision:
		get_parent().velocity.x = -velocity.x
