extends Button

@onready var button = $"."

func _ready():
	button.connect("mouse_entered", _on_mouse_entered)
	button.connect("mouse_exited", _on_mouse_exited)
	button.connect("pressed", _on_button_pressed)

func _on_mouse_entered():
	button.modulate = Color(1.2, 1.2, 1.2)

func _on_mouse_exited():
	button.modulate = Color(1, 1, 1)

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scene/main.tscn")
