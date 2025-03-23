class_name HealthBar
extends HBoxContainer

@export var full_health_texture: Texture2D

@export var empty_health_texure: Texture2D

func set_health(value: int) -> void:
	if value < 0:
		return
	for i in get_child_count():
		if i < value:
			(get_child(i) as TextureRect).texture = full_health_texture
		else:
			(get_child(i) as TextureRect).texture = empty_health_texure
