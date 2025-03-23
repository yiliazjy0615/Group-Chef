class_name DishEntity
extends Node2D

@export var sprite: Sprite2D

@export var food_resource: FoodResource
@export var sprite_scale: Vector2 = Vector2(3.0, 3.0)

func is_inside() -> bool:
	var mouse_position: Vector2 = sprite.get_local_mouse_position()
	return sprite.is_pixel_opaque(mouse_position)
