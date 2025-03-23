func _ready():
	var catpaw_cursor = load("res://CatpawMouseIcon.png")
	print(catpaw_cursor)  # Check if it loads correctly
	Input.set_custom_mouse_cursor(catpaw_cursor, Input.CURSOR_ARROW, Vector2(30, 30))
