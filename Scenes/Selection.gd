extends Node

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var Player = load("res://Scenes/GameState.tscn")
var Player2 = load("res://Scenes/GameState2.tscn")
var Player3 = load("res://Scenes/GameState3.tscn")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if $Button:
		if $Button.pressed:
			get_tree().change_scene_to(Player)
	if $Button2:
		if $Button2.pressed:
			get_tree().change_scene_to(Player2)
	if $Button3:
		if $Button3.pressed:
			get_tree().change_scene_to(Player3)
