extends Node2D

func _ready():
	var cursor_texture = load("res://可以用的/Sprout Lands - UI Pack - Basic pack/Sprite sheets/Mouse sprites/Triangle Mouse icon 3.png")  # Change to your cursor path
	Input.set_custom_mouse_cursor(cursor_texture)
