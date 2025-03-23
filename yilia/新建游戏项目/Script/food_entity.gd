class_name FoodEntity
extends Node2D

@export var food_resource: FoodOutputResource
@export var sprite: Sprite2D

var start_mouse_position: Vector2
var start_drag_position: Vector2
var is_dragging: bool = false

signal submit

func set_resource(fr: FoodOutputResource) -> void:
	food_resource = fr
	if food_resource != null:
		sprite.texture = food_resource.texture
	else:
		sprite.texture = null

func _process(_delta: float) -> void:
	if is_dragging:
		var offset: Vector2 = get_global_mouse_position() - start_mouse_position
		position = start_drag_position + offset

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		if is_inside() and is_active():
			is_dragging = true
			start_mouse_position = get_global_mouse_position()
			start_drag_position = position
	elif event.is_action_released("click"):
		is_dragging = false
		if is_active():
			submit.emit()

func is_inside() -> bool:
	var mouse_position: Vector2 = sprite.get_local_mouse_position()
	return sprite.is_pixel_opaque(mouse_position)

func is_active() -> bool:
	return food_resource != null
